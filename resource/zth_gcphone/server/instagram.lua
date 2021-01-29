--====================================================================================
-- #Author: zThundy__
--====================================================================================


--===============================
-- SEZIONE FUNZIONI PER INSTAGRAM
--===============================



function InstagramShowError(player, title, message)
	TriggerClientEvent('gcPhone:instagram_showError', player, title, message)
end



function InstagramShowSuccess(player, title, message)
	TriggerClientEvent('gcPhone:instagram_showSuccess', player, title, message)
end



function InstagramGetPosts(accountId, cb)
	if accountId == nil then
		MySQL.Async.fetchAll([===[
			SELECT phone_instagram_posts.*,
				phone_instagram_accounts.username as author,
				phone_instagram_accounts.avatar_url as authorIcon
			FROM phone_instagram_posts
			LEFT JOIN phone_instagram_accounts
				ON phone_instagram_posts.authorId = phone_instagram_accounts.id
			ORDER BY data DESC LIMIT 130
		]===], {}, cb)
	else
	  	MySQL.Async.fetchAll([===[
			SELECT phone_instagram_posts.*,
				phone_instagram_accounts.username as author,
				phone_instagram_accounts.avatar_url as authorIcon,
				phone_instagram_likes.id AS isLike
			FROM phone_instagram_posts
			LEFT JOIN phone_instagram_accounts
				ON phone_instagram_posts.authorId = phone_instagram_accounts.id
			LEFT JOIN phone_instagram_likes 
				ON phone_instagram_posts.id = phone_instagram_likes.postId AND phone_instagram_likes.authorId = @accountId
			ORDER BY data DESC LIMIT 130
	  	]===], {['@accountId'] = accountId}, cb)
	end
end



function instagramGetPosts(data, cb)
	MySQL.Async.fetchAll("SELECT * FROM phone_instagram_posts", {}, function(result)
		cb(result)
	end)
end



function getInstagramUser(username, password, cb)
	MySQL.Async.fetchAll("SELECT * FROM phone_instagram_accounts WHERE username = @username AND password = @password", {['@username'] = username, ['@password'] = password}, function(data)
		if #data > 0 then
			-- print(ESX.DumpTable(data[1]))
			cb(data[1])
		else
			cb(false)
		end
	end)
end



function createNewInstagramAccount(username, password, avatarUrl, cb)
	MySQL.Async.insert('INSERT IGNORE INTO phone_instagram_accounts(`username`, `password`) VALUES(@username, @password)', {
	  ['@username'] = username,
	  ['@password'] = password
	}, cb)
end



--=============================
-- SEZIONE EVENTI PER INSTAGRAM
--=============================

--[[
	RICEVI DA NUI

	{
		didascalia: valueText.text,
		filter: this.filters[this.selectedMessage],
		message: this.tempImage
	}

	DEVI INVIARE
	{
		id: 1,
		message: 'https://pbs.twimg.com/profile_images/702982240184107008/tUKxvkcs_400x400.jpg',
		author: 'Gannon',
		time: new Date(),
		description: 'Questo testo è una prova. Da qua sto testando cosa succede se scrivi un cazzo di poema',
		likes: 3,
		filter: 'moon',
		isLike: 1
	}
]]


RegisterServerEvent("gcPhone:instagram_nuovoPost")
AddEventHandler("gcPhone:instagram_nuovoPost", function(username, password, data)
	local player = source
	local identifier = gcPhone.getPlayerID(player)

	gcPhone.isAbleToSurfInternet(identifier, 0.5, function(isAble, mbToRemove)
		if isAble then
			gcPhone.usaDatiInternet(identifier, mbToRemove)

			getInstagramUser(username, password, function(user)
				if user == false then
					InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NO_ACCOUNT')
					return
				end

				MySQL.Async.insert("INSERT INTO phone_instagram_posts (`authorId`, `image`, `identifier`, `filter`, `didascalia`) VALUES(@authorId, @message, @identifier, @filter, @didascalia)", {
						['@authorId'] = user.id,
						['@message'] = data.message,
						['@identifier'] = identifier,
						['@filter'] = data.filter,
						['@didascalia'] = data.didascalia
				}, function(id)

					MySQL.Async.fetchAll('SELECT * from phone_instagram_posts WHERE id = @id', {['@id'] = id}, function(posts)
						post = posts[1]
						post['author'] = user.author
						post['authorIcon'] = user.authorIcon
						TriggerClientEvent('gcPhone:instagram_newPostToNUI', -1, post)
					end)

				end)
			end)
		else
			InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
		end
	end)

end)



RegisterServerEvent('gcPhone:instagram_getPosts')
AddEventHandler('gcPhone:instagram_getPosts', function(username, password)
	local player = source
	local identifier = gcPhone.getPlayerID(player)
	
	if username ~= nil and username ~= "" and password ~= nil and password ~= "" then

  		gcPhone.isAbleToSurfInternet(identifier, 1, function(isAble, mbToRemove)
			if isAble then
				gcPhone.usaDatiInternet(identifier, mbToRemove)
				
				-- funzione che controlla se l'utente esista effettivamente
				getInstagramUser(username, password, function(user)
					if user == false then
						InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NO_ACCOUNT')
						return
					end

					-- questa funzione ti ritorna la table già bella
					-- buildata da mandare a nui
      				local accountId = user and user.id
					InstagramGetPosts(accountId, function(posts)
						
      					gcPhone.isAbleToSurfInternet(identifier, 0.04 * #posts, function(isAble, mbToRemove)
							if isAble then
								gcPhone.usaDatiInternet(identifier, mbToRemove)
								
        						TriggerClientEvent('gcPhone:instagram_updatePosts', player, posts)
        					else
  								InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
  							end
  						end)
      				end)
    			end)
  			else
  				InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
  			end
  		end)
  	else
  		gcPhone.isAbleToSurfInternet(identifier, 1, function(isAble, mbToRemove)
			if isAble then
				gcPhone.usaDatiInternet(identifier, mbToRemove)
				
				InstagramGetPosts(nil, function(posts)
					
    				gcPhone.isAbleToSurfInternet(identifier, 0.04 * #posts, function(isAble, mbToRemove)
						if isAble then
							gcPhone.usaDatiInternet(identifier, mbToRemove)
							
      						TriggerClientEvent('gcPhone:instagram_updatePosts', player, posts)
      					else
  							InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
  						end
  					end)
    			end)
  			else
  				InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
  			end
  		end)
  	end
end)



RegisterServerEvent('gcPhone:instagram_createAccount')
AddEventHandler('gcPhone:instagram_createAccount', function(username, password, avatarUrl)
	local player = source
	local identifier = gcPhone.getPlayerID(player)
  	
	gcPhone.isAbleToSurfInternet(identifier, 0.5, function(isAble, mbToRemove)
		if isAble then
			gcPhone.usaDatiInternet(identifier, mbToRemove)
			
			createNewInstagramAccount(username, password, avatarUrl, function(id)

    			if id ~= 0 then
					TriggerClientEvent('gcPhone:instagram_setAccount', player, username, password, avatarUrl)
					  
      				InstagramShowSuccess(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_ACCOUNT_CREATED')
    			else
					InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_ACCOUNT_CREATE_ERROR')
    			end
  			end)
  		else
			InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
  		end
  	end)
end)



RegisterServerEvent("gcPhone:instagram_loginAccount")
AddEventHandler("gcPhone:instagram_loginAccount", function(username, password)
	local player = source
	local identifier = gcPhone.getPlayerID(player)
	
	gcPhone.isAbleToSurfInternet(identifier, 0.5, function(isAble, mbToRemove)
		if isAble then
			gcPhone.usaDatiInternet(identifier, mbToRemove)

			getInstagramUser(username, password, function(user)
				if user == false then
					InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NO_ACCOUNT')
      				return
				end
				
				if user == nil then
      				InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
    			else
					InstagramShowSuccess(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_LOGIN_SUCCESS')

      				TriggerClientEvent('gcPhone:instagram_setAccount', player, username, password, user.avatar_url)
    			end
  			end)
  		else
  			InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
  		end
  	end)
end)


RegisterServerEvent("gcPhone:instagram_changePassword")
AddEventHandler("gcPhone:instagram_changePassword", function(username, password, newPassword)
	local player = source
	local identifier = gcPhone.getPlayerID(player)
	
	gcPhone.isAbleToSurfInternet(identifier, 0.5, function(isAble, mbToRemove)
		if isAble then
			gcPhone.usaDatiInternet(identifier, mbToRemove)

			getInstagramUser(username, password, function(user)
				if user == false then
					InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NO_ACCOUNT')
      				return
				end
				
				if user == nil then
      				InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
    			else
      				MySQL.Async.execute("UPDATE phone_instagram_accounts SET password = @newpassword WHERE username = @username AND password = @password", {
						['@username'] = username,
						['@password'] = password, 
						['@newpassword'] = newPassword
					}, function()

						InstagramShowSuccess(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_PASSCHANGE_SUCCESS')
					end)
    			end
  			end)
  		else
  			InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
  		end
  	end)
end)



RegisterServerEvent('gcPhone:instagram_toggleLikePost')
AddEventHandler('gcPhone:instagram_toggleLikePost', function(username, password, postId)
	local player = source
	local identifier = gcPhone.getPlayerID(player)
	
	gcPhone.isAbleToSurfInternet(identifier, 0.02, function(isAble, mbToRemove)
		if isAble then
			gcPhone.usaDatiInternet(identifier, mbToRemove)
			
			getInstagramUser(username, password, function(user)
    			if user == nil then
      				if player ~= nil then
        				InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
      				end
      				return
				end
				
				if user == false then
					InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NO_ACCOUNT')
      				return
				end

    			MySQL.Async.fetchAll('SELECT * FROM phone_instagram_posts WHERE id = @id', {['@id'] = postId}, function(posts)
					local post = posts[1]
					if post == nil then
						InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_POST_NOT_FOUND')
						return
					end
					
      				MySQL.Async.fetchAll('SELECT * FROM phone_instagram_likes WHERE authorId = @authorId AND postId = @postId', {
        				['@authorId'] = user.id,
        				['@postId'] = postId
					}, function(row) 
						
						if row[1] == nil then
							
          					MySQL.Async.insert('INSERT INTO phone_instagram_likes (`authorId`, `postId`) VALUES(@authorId, @postId)', {
            					['@authorId'] = user.id,
            					['@postId'] = postId
							  }, function(newrow)
								
            					MySQL.Async.execute('UPDATE `phone_instagram_posts` SET `likes`= likes + 1 WHERE id = @id', {['@id'] = post.id}, function()
									
									-- questo evento aggiorna i like per tutti i giocatori
									TriggerClientEvent('gcPhone:instagram_updatePostLikes', -1, post.id, post.likes + 1)
									-- questo evento aggiorna il colore del cuore per chi lo mette
									TriggerClientEvent('gcPhone:instagram_updateLikeForUser', player, post.id, true)
									  
            					end)    
          					end)
						else
							MySQL.Async.execute('DELETE FROM phone_instagram_likes WHERE id = @id', {['@id'] = row[1].id}, function()
								
								MySQL.Async.execute('UPDATE `phone_instagram_posts` SET `likes`= likes - 1 WHERE id = @id', {['@id'] = post.id}, function()
									
									-- questo evento aggiorna i like per tutti i giocatori
									TriggerClientEvent('gcPhone:instagram_updatePostLikes', -1, post.id, post.likes - 1)
									-- questo evento aggiorna il colore del cuore per chi lo mette
									TriggerClientEvent('gcPhone:instagram_updateLikeForUser', player, post.id, false)
									  
            					end)
          					end)
        				end
      				end)
    			end)
			end)
		else
  			InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
  		end
  	end)
end)



RegisterServerEvent('gcPhone:instagram_setAvatarurl')
AddEventHandler('gcPhone:instagram_setAvatarurl', function(username, password, avatarUrl)
	local player = source
	local identifier = gcPhone.getPlayerID(player)

	gcPhone.isAbleToSurfInternet(identifier, 0.5, function(isAble, mbToRemove)
		if isAble then
			gcPhone.usaDatiInternet(identifier, mbToRemove)
			
			getInstagramUser(username, password, function(user)

				MySQL.Async.execute("UPDATE phone_instagram_accounts SET avatar_url = @avatarUrl WHERE username = @username AND password = @password", {
					['@username'] = username,
					['@password'] = password,
					['@avatarUrl'] = avatarUrl
				}, function(result)
					if result == 1 then
						TriggerClientEvent('gcPhone:instagram_setAccount', player, username, password, avatarUrl)
						
						TwitterShowSuccess(player, 'Twitter Info', 'APP_INSTAGRAM_NOTIF_AVATAR_SUCCESS')
					else
						InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_LOGIN_ERROR')
					end
				end)
			end)
		else
			InstagramShowError(player, 'INSTAGRAM_INFO_TITLE', 'APP_INSTAGRAM_NOTIF_NO_CONNECTION')
		end
	end)
end)