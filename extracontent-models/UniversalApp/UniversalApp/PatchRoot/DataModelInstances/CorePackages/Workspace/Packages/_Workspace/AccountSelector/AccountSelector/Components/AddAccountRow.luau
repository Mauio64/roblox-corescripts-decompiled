local ParentParent = script.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local SelectionRow = require(script.Parent.SelectionRow)
local useLocalization = dependencies.Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local Images = UIBlox.App.ImageSet.Images
local AnalyticsEvents = require(ParentParent.Analytics.AnalyticsEvents)
local EventConstants = require(ParentParent.Analytics.EventConstants)

local function AddAccountRow(t1: {[any]: any}) -- line: 24
	-- upvalues: useLocalization (copy), useStyle (copy), React (copy), ImageSetLabel (copy), Images (copy), AnalyticsEvents (copy), EventConstants (copy), SelectionRow (copy)
	local v14 = useLocalization({
		addAccountText = "Authentication.AccountSwitch.Action.AddAccount"
	})
	local v15 = useStyle()

	local function renderPlusIcon() -- line: 30
		-- upvalues: React (copy), v15 (copy), ImageSetLabel (copy), Images (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 0.6,
			Size = UDim2.new(0, 48, 0, 48),
			BackgroundColor3 = v15.Theme.IconDefault.Color
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 24)
			}),
			Icon = React.createElement(ImageSetLabel, {
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 16, 0, 16),
				Image = Images["icons/common/plus_small"],
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				ImageColor3 = v15.Theme.BackgroundContrast.Color
			})
		})
	end
	local function onRowClickedCallback() -- line: 51
		-- upvalues: t1 (copy), AnalyticsEvents (copy), EventConstants (copy)
		t1.onRowClicked()
		AnalyticsEvents.sendButtonClickEvent(t1.context, t1.origin, EventConstants.btn.addAccount)
	end

	return React.createElement(SelectionRow, {
		subtitleContent = "",
		userInteractionEnabled = true,
		titleContent = v14.addAccountText,
		renderImage = renderPlusIcon,
		onAccountSelection = onRowClickedCallback
	})
end

return AddAccountRow
