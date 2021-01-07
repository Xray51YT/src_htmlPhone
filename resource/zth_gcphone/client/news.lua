RegisterNUICallback("fetchNews", function(data, cb)
    TriggerServerEvent("gcphone:news_requestEmails")
    cb("ok")
end)


RegisterNetEvent("gcphone:news_sendRequestedNews")
AddEventHandler("gcphone:news_sendRequestedNews", function(news)
    SendNUIMessage({ event = "sendRequestedNews", news = news })
end)


RegisterNUICallback("postNews", function(data, cb)
    TriggerServerEvent("gcphone:news_sendNewPost", data)
    cb("ok")
end)


RegisterNUICallback("requestJob", function(data, cb)
    ESX.TriggerServerCallback("gcphone:news_requestMyJob", function(job)
        SendNUIMessage({ event = "receiveNewsJob", job = job })
    end)
    cb("ok")
end)