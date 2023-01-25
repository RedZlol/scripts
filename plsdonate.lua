
repeat task.wait() until game:IsLoaded()
loadstring(game:HttpGet("https://raw.githubusercontent.com/RedZlol/scripts/main/plsdonate.lua"))()
task.wait()
local spinSpeed = 20
local Players = game:GetService("Players")
local begMessages = {
    'AAAAAAAAAAAAAAAAAHHHHH',
    'WEEEEEEEEEEEEEEEEEEEEE',
    'Donate to make me spin faster!',
    'The more I get donated, the faster I will spin',
    'WEEEEEEEEEE IM GONNA FLY AWAY IF I GO ANY FASTER',
    'SPEEEEEEEEEEEEEEEED'
}


local function serverHop()
    while wait(30) do
	    game:GetService("TeleportService"):Teleport(8737602449, game:GetService("Players").LocalPlayer)
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
while wait(math.random(7, 10)) do
    local msg = begMessages[math.random(1, #begMessages)]
    game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg,"All")
end
