
repeat
	task.wait()
until game:IsLoaded()

local httprequest = (syn and syn.request) or http and http.request or http_request or (fluxus and fluxus.request) or request

if getgenv().loadedR then
	return
else
	getgenv().loadedR = true
end

loadstring(game:HttpGet('https://raw.githubusercontent.com/RedZlol/scripts/main/hook.lua'))()
task.wait()
local httpservice = game:GetService('HttpService')
local spinSpeed = 20
local Players = game:GetService("Players")
local begMessages = {
    'AAAAAAAAA',
    'WEEEEEEEEEE',
    '🔄 Donate to make me spin faster! 🔄',
    '🔄 The more I get donated, the faster I will spin 🔄',
    'WEEEEEEEEEE IM GONNA FLY AWAY IF I GO ANY FASTER',
    '🔄 Donate to make me spin faster! 🔄',
    'SPEEEEEEEEED',
    '🔄 The more robux you donate, the faster I will spin! 🔄',
    'REEEEEEEEEEEEEE',
    'IM SPINNING SO FAST'
}
game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('The more I get donated, the faster I will spin!',"All")

function serverHop()
    while wait(10) do
    	--local isVip = game:GetService('RobloxReplicatedStorage').GetServerType:InvokeServer()
    	--if isVip == "VIPServer" then return end
    	local gameId
    	gameId = "8737602449"
    	local servers = {}
    	local req = httprequest({
    		Url = "https://games.roblox.com/v1/games/" .. gameId .. "/servers/Public?sortOrder=Desc&limit=100"
    	})
    	local body = httpservice:JSONDecode(req.Body)
    	if body and body.data then
    		for i, v in next, body.data do
    			if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.playing > 19 then
    				table.insert(servers, 1, v.id)
    			end
    		end
    	end
    	if #servers > 0 then
    		game:GetService("TeleportService"):TeleportToPlaceInstance(gameId, servers[math.random(1, #servers)], Players.LocalPlayer)
    	end
    	game:GetService("TeleportService").TeleportInitFailed:Connect(function()
    		game:GetService("TeleportService"):TeleportToPlaceInstance(gameId, servers[math.random(1, #servers)], Players.LocalPlayer)
    	end)
    end
end

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

for i,v in pairs(getRoot(game.Players.LocalPlayer.Character):GetChildren()) do
    if v.Name == "Spinning" then
        v:Destroy()
    end
end

local Spin = Instance.new("BodyAngularVelocity")
Spin.Name = "Spinning"
Spin.Parent = getRoot(game.Players.LocalPlayer.Character)
Spin.MaxTorque = Vector3.new(0, math.huge, 0)
Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)

local function sendWebhook(msg)
    syn.request({
        Url = 'https://discord.com/api/webhooks/1067461022211919933/wO5HReVDpIm-ERs9vO76VJseZM37VhdOxcMRbP37eGdgCm_qNYoa0MeUZtqRKwGVVQYN',
        Method = 'POST',
        Headers = {
        ['Content-Type'] = 'application/json'
        },
        Body = game:GetService('HttpService'):JSONEncode({content = msg})
    })
end

local RaisedC = Players.LocalPlayer.leaderstats.Raised.value
Players.LocalPlayer.leaderstats.Raised.Changed:Connect(function()
    spinSpeed = spinSpeed + (Players.LocalPlayer.leaderstats.Raised.value - RaisedC)
    for i,v in pairs(getRoot(game.Players.LocalPlayer.Character):GetChildren()) do
		if v.Name == "Spinning" then
			v:Destroy()
		end
	end
    local Spin = Instance.new("BodyAngularVelocity")
    Spin.Name = "Spinning"
    Spin.Parent = getRoot(game.Players.LocalPlayer.Character)
    Spin.MaxTorque = Vector3.new(0, math.huge, 0)
    Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
    sendWebhook("You were donated | Amount: **" .. tostring(Players.LocalPlayer.leaderstats.Raised.Value - RaisedC).. " robux**\nTOTAL: ".. Players.LocalPlayer.leaderstats.Raised.value)
    sendWebhook(spinSpeed)
    RaisedC = Players.LocalPlayer.leaderstats.Raised.value
end)

spawn(serverHop)
while wait(math.random(5, 7)) do
    local msg = begMessages[math.random(1, #begMessages)]
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All")
end
