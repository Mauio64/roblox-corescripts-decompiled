local parent = script:FindFirstAncestor("GameJoinCard").Parent
local React = require(parent.React)

local SharedFlags = require(parent.SharedFlags)
local FFlagBlockEDPClickthrough = SharedFlags.FFlagBlockEDPClickthrough

local function useGameJoinCardNavigation(instance, flag: boolean, p)
	local state, setState = React.useState(false)

	React.useEffect(function()
		if not instance then
			setState(false)
			return
		end

		local GuiService = game:GetService("GuiService")
		local function checkFocus() -- 1 equivalent call inferred from this helper
			local selectedCoreObject = GuiService.SelectedCoreObject
			setState(selectedCoreObject ~= nil and (selectedCoreObject == instance or selectedCoreObject:IsDescendantOf(instance)) and selectedCoreObject:FindFirstAncestorOfClass("CoreGui") ~= nil)
		end

		checkFocus() -- inferred equivalent call
		local selectedCoreObjectChangedConnection = GuiService:GetPropertyChangedSignal("SelectedCoreObject"):Connect(checkFocus)
		return function()
			selectedCoreObjectChangedConnection:Disconnect()
		end
	end, { instance })

	React.useEffect(function()
		if not (flag and instance) then
			return
		end

		local current = p.current

		if not current then
			return
		end

		local content = current:FindFirstChild("Content", true)

		if not content then
			return
		end

		local function wireNavigation()
			if FFlagBlockEDPClickthrough then
				local platformName = instance:FindFirstChild("PlatformName", true)

				if platformName then
					content.NextSelectionDown = platformName
					platformName.NextSelectionUp = content
				end
			else
				local thumbnail = instance:FindFirstChild("Thumbnail", true)
				local gameName = instance:FindFirstChild("GameName", true)
				local platformName = instance:FindFirstChild("PlatformName", true)

				if thumbnail then
					content.NextSelectionDown = thumbnail
					thumbnail.NextSelectionUp = content
				end

				if gameName then
					gameName.NextSelectionUp = content
				end

				if platformName then
					platformName.NextSelectionUp = gameName or content

					if gameName then
						gameName.NextSelectionDown = platformName
					end
				end
			end
		end

		wireNavigation()
		local descendantAddedConnection = instance.DescendantAdded:Connect(wireNavigation)

		return function()
			descendantAddedConnection:Disconnect()

			if content and content.Parent then
				content.NextSelectionDown = nil
			end

			if not FFlagBlockEDPClickthrough then
				local thumbnail = instance:FindFirstChild("Thumbnail", true)

				if thumbnail and thumbnail.Parent then
					thumbnail.NextSelectionUp = nil
				end

				local gameName = instance:FindFirstChild("GameName", true)

				if gameName and gameName.Parent then
					gameName.NextSelectionUp = nil
					gameName.NextSelectionDown = nil
				end
			end

			local platformName = instance:FindFirstChild("PlatformName", true)

			if platformName and platformName.Parent then
				platformName.NextSelectionUp = nil
				platformName.NextSelectionDown = nil
			end
		end
	end, { instance, flag })

	return state
end

return useGameJoinCardNavigation
