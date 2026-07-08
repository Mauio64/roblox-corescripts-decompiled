local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local ParentParent = script.Parent.Parent.Parent
local FTUXSlideshowData = require(ParentParent.Resources.FTUXSlideshowData)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)

require(ParentParent.Enums.PlatformEnum)

local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization

local function Description(t1: {[any]: any}) -- line: 19
	-- upvalues: useStyle (copy), FTUXSlideshowData (copy), withLocalization (copy), React (copy), LuauPolyfill (copy), UIBlox (copy)
	local v11 = useStyle()
	local Theme = v11.Theme
	local Font = v11.Font
	local text = FTUXSlideshowData[t1.platform][t1.currentIndex].text

	return withLocalization(text)(function(p1) -- line: 28
		-- upvalues: React (copy), LuauPolyfill (copy), text (copy), UIBlox (copy), Font (copy), Theme (copy)
		return React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0.4, 0),
			Position = UDim2.new(0, 0, 0, 0)
		}, React.createElement("UIListLayout", {
			Padding = UDim.new(0, 0),
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}), LuauPolyfill.Array.map(text, function(_, p3) -- line: 43
			-- upvalues: React (copy), UIBlox (copy), p1 (copy), Font (copy), Theme (copy), text (copy)
			return (React.createElement(UIBlox.App.Text.StyledTextLabel, {
				text = p1[p3],
				fontStyle = Font.CaptionBody,
				colorStyle = Theme.TextDefault,
				textXAlignment = Enum.TextXAlignment.Left,
				size = UDim2.new(1, 0, 1 / #text, 0),
				layoutOrder = p3
			}))
		end))
	end)
end

return Description
