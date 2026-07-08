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

return function(p1) -- line: 15
	-- upvalues: React (copy), RobloxTranslator (copy), CoreGui (copy), TooltipOrientation (copy), UserInputService (copy), Promise (copy), withTooltip (copy)
	local v11, v12 = React.useState(true)
	local fallbackText = p1.fallbackText

	pcall(function() -- line: 19
		-- upvalues: fallbackText (ref), RobloxTranslator (copy), p1 (copy)
		fallbackText = RobloxTranslator:FormatByKey(p1.translationKey)
	end)

	local t1 = {
		textAlignment = Enum.TextXAlignment.Left,
		bodyText = fallbackText
	}
	local t2 = {
		DisplayOrder = 10,
		active = v11,
		guiTarget = CoreGui,
		preferredOrientation = TooltipOrientation.Left
	}
	local u16 = nil

	u16 = UserInputService.InputBegan:Connect(function(input) -- line: 44
		-- upvalues: v12 (copy), u16 (ref)
		local UserInputType = input.UserInputType

		if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch then
			v12(false)

			if u16 then
				u16:Disconnect()
				u16 = nil
			end
		end
	end)
	Promise.delay(p1.tooltipLifetime):andThen(function() -- line: 50
		-- upvalues: v12 (copy), u16 (ref)
		v12(false)

		if u16 then
			u16:Disconnect()
			u16 = nil
		end
	end)

	return withTooltip(t1, t2, function(p2) -- line: 54
		-- upvalues: React (copy)
		local function v20(p3) -- line: 55
			-- upvalues: p2 (copy)
			p2(p3)
		end

		return React.createElement("Frame", {
			Visible = false,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			[React.Change.AbsoluteSize] = v20,
			[React.Change.AbsolutePosition] = v20
		})
	end)
end
