lp = game:GetService("Players").LocalPlayer
local oldhook

oldhook = hookmetamethod(game, "__namecall", function(Self, ...)
	local method = getnamecallmethod()

	if Self == lp and (method == "Kick" or method == "kick") then
		return warn('no')
	end

	return oldhook(Self, ...)
end)

task.spawn(function()
   while task.wait(10) do
	if getgenv().loaded then getgenv().loaded = false game:GetService('CoreGui'):WaitForChild('imgui'):Destroy() loadstring(game:HttpGet("https://raw.githubusercontent.com/RedZlol/scripts/main/plsdonate.lua"))() end
   end
end)
