gcPhoneT.news_requestMyJob = function()
    local player = source
    local xPlayer = ESX.GetPlayerFromId(player)
    return xPlayer.job.name
end

gcPhoneT.news_requestNews = function()
    local player = source
    GetFetchedNews(function(news)
        TriggerClientEvent("gcphone:news_sendRequestedNews", player, news)
    end)
end

gcPhoneT.news_sendNewPost = function(data)
    MySQL.Async.execute("INSERT INTO phone_news(message, pics) VALUES(@message, @pics)", {
        ['@message'] = data.message,
        ['@pics'] = json.encode(data.pics)
    }, function()
	    local player = source
        GetFetchedNews(function(news)
            TriggerClientEvent("gcphone:news_sendRequestedNews", player, news)
        end)
    end)
end

function GetFetchedNews(cb)
    MySQL.Async.fetchAll("SELECT * FROM phone_news ORDER BY id DESC LIMIT 50", {}, function(result)
        for k, v in pairs(result) do
            v.pics = json.decode(v.pics)
        end

        cb(result)
    end)
end