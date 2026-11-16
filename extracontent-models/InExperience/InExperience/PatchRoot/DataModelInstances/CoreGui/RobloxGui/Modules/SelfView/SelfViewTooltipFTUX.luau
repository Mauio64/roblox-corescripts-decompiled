local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
CoreGui:WaitForChild("RobloxGui")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local withTooltip = UIBlox.App.Dialog.TooltipV2.withTooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local Promise = require(CorePackages.Packages.Promise)

return function(data)
	local state, setState = React.useState(true)

	local bodyText = data.fallbackText
	pcall(function()
		bodyText = RobloxTranslator:FormatByKey(data.translationKey)
	end)

	local v = { textAlignment = Enum.TextXAlignment.Left, bodyText = bodyText }

	local v2 = {
		active = state,
		guiTarget = CoreGui,
		DisplayOrder = 10,
		preferredOrientation = TooltipOrientation.Left
	}

	local inputBeganConnection = nil
	local function fn() -- 2 equivalent calls inferred from this helper
		setState(false)

		if inputBeganConnection then
			inputBeganConnection:Disconnect()
			inputBeganConnection = nil
		end
	end

	inputBeganConnection = UserInputService.InputBegan:Connect(function(input)
		local userInputType = input.UserInputType

		if userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.Touch then
			fn() -- inferred equivalent call
		end
	end)
	Promise.delay(data.tooltipLifetime):andThen(function()
		fn() -- inferred equivalent call
	end)

	return withTooltip(v, v2, function(callback)
		local function fn2(p)
			callback(p)
		end
		return React.createElement("Frame", {
			Visible = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[React.Change.AbsoluteSize] = fn2,
			[React.Change.AbsolutePosition] = fn2
		})
	end)
end
