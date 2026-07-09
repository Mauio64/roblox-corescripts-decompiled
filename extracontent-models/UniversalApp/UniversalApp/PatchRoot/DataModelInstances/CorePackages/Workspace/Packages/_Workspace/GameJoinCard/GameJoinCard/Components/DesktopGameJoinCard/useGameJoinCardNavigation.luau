local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local React = require(Parent.React)
local FFlagPPVEnabledOnConsole = require(Parent.SharedFlags).FFlagPPVEnabledOnConsole
local FFlagEnableConsoleGameJoinCard = require(Parent.SharedFlags).FFlagEnableConsoleGameJoinCard
local FFlagBlockEDPClickthrough = require(Parent.SharedFlags).FFlagBlockEDPClickthrough

local function useGameJoinCardNavigation(p1, b1: boolean, p2) -- line: 9
	-- upvalues: React (copy), FFlagPPVEnabledOnConsole (copy), FFlagEnableConsoleGameJoinCard (copy), FFlagBlockEDPClickthrough (copy)
	local v10, v11 = React.useState(false)

	React.useEffect(function() -- line: 12
		-- upvalues: p1 (copy), v11 (copy)
		if not p1 then
			v11(false)

			return
		end

		local GuiService = game:GetService("GuiService")

		local function checkFocus() -- line: 18
			-- upvalues: GuiService (copy), v11 (copy), p1 (copy)
			local SelectedCoreObject = GuiService.SelectedCoreObject

			v11(SelectedCoreObject ~= nil and ((SelectedCoreObject == p1 or SelectedCoreObject:IsDescendantOf(p1)) and SelectedCoreObject:FindFirstAncestorOfClass("CoreGui") ~= nil))
		end

		local SelectedCoreObject = GuiService.SelectedCoreObject

		v11(SelectedCoreObject ~= nil and ((SelectedCoreObject == p1 or SelectedCoreObject:IsDescendantOf(p1)) and SelectedCoreObject:FindFirstAncestorOfClass("CoreGui") ~= nil))

		local connection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(checkFocus)

		return function() -- line: 28
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { p1 })
	React.useEffect(function() -- line: 33
		-- upvalues: FFlagPPVEnabledOnConsole (copy), FFlagEnableConsoleGameJoinCard (copy), b1 (copy), p1 (copy), p2 (copy), FFlagBlockEDPClickthrough (copy)
		if not FFlagPPVEnabledOnConsole and not FFlagEnableConsoleGameJoinCard or not b1 then
			return
		end

		if not p1 then
			return
		end

		local current = p2.current

		if not current then
			return
		end

		local Content = current:FindFirstChild("Content", true)

		if not Content then
			return
		end

		local function wireNavigation() -- line: 49
			-- upvalues: FFlagBlockEDPClickthrough (copy), p1 (copy), Content (copy)
			if FFlagBlockEDPClickthrough then
				local PlatformName = p1:FindFirstChild("PlatformName", true)

				if PlatformName then
					Content.NextSelectionDown = PlatformName
					PlatformName.NextSelectionUp = Content
				end

				return
			end

			local Thumbnail = p1:FindFirstChild("Thumbnail", true)
			local GameName = p1:FindFirstChild("GameName", true)
			local PlatformName = p1:FindFirstChild("PlatformName", true)

			if Thumbnail then
				Content.NextSelectionDown = Thumbnail
				Thumbnail.NextSelectionUp = Content
			end

			if GameName then
				GameName.NextSelectionUp = Content
			end

			if PlatformName then
				PlatformName.NextSelectionUp = GameName or Content

				if GameName then
					GameName.NextSelectionDown = PlatformName
				end
			end
		end

		wireNavigation()

		local connection = p1.DescendantAdded:Connect(wireNavigation)

		return function() -- line: 80
			-- upvalues: connection (copy), Content (copy), FFlagBlockEDPClickthrough (copy), p1 (copy)
			connection:Disconnect()

			if Content and Content.Parent then
				Content.NextSelectionDown = nil
			end

			if not FFlagBlockEDPClickthrough then
				local Thumbnail = p1:FindFirstChild("Thumbnail", true)

				if Thumbnail and Thumbnail.Parent then
					Thumbnail.NextSelectionUp = nil
				end

				local GameName = p1:FindFirstChild("GameName", true)

				if GameName and GameName.Parent then
					GameName.NextSelectionUp = nil
					GameName.NextSelectionDown = nil
				end
			end

			local PlatformName = p1:FindFirstChild("PlatformName", true)

			if PlatformName and PlatformName.Parent then
				PlatformName.NextSelectionUp = nil
				PlatformName.NextSelectionDown = nil
			end
		end
	end, {
		p1,
		b1
	})

	return v10
end

return useGameJoinCardNavigation
