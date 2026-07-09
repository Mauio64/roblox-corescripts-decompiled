local ChallengeDialog = script:FindFirstAncestor("ChallengeDialog")
local UserInputService = game:GetService("UserInputService")
local ChallengeDialogParent = ChallengeDialog.Parent
local React = require(ChallengeDialogParent.React)
local UIBlox = require(ChallengeDialogParent.UIBlox)
local RoactUtils = require(ChallengeDialogParent.RoactUtils)
local screenSizeSelector = require(ChallengeDialog.Common.Utils).screenSizeSelector
local getMiddleContentWidth = require(ChallengeDialog.Common.Utils).getMiddleContentWidth
local getAdjustedTitleToScreenString = require(ChallengeDialog.Common.Utils).getAdjustedTitleToScreenString
local DEFAULT_PADDING = require(ChallengeDialog.Common.Constants).DEFAULT_PADDING
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local withStyle = UIBlox.Core.Style.withStyle
local FullPageModal = UIBlox.App.Dialog.Modal.FullPageModal

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: useSelector (copy), screenSizeSelector (copy), getMiddleContentWidth (copy), UserInputService (copy), withStyle (copy), getAdjustedTitleToScreenString (copy), React (copy), FullPageModal (copy), DEFAULT_PADDING (copy)
	local v15 = useSelector(screenSizeSelector)
	local v16 = getMiddleContentWidth(v15.X)
	local StatusBarSizeY = UserInputService.StatusBarSize.Y
	local buttonConfig = t1.buttonConfig
	local makeBodyFragment = t1.makeBodyFragment
	local footerContent = t1.footerContent
	local v21 = not t1.hideCloseButton
	local title = t1.title

	return withStyle(function(p1) -- line: 38
		-- upvalues: getAdjustedTitleToScreenString (copy), title (copy), v16 (copy), React (copy), FullPageModal (copy), v15 (copy), buttonConfig (copy), v21 (copy), t1 (copy), StatusBarSizeY (copy), footerContent (copy), DEFAULT_PADDING (copy), makeBodyFragment (copy)
		local v24 = getAdjustedTitleToScreenString(title, v16, p1)

		return React.createElement(FullPageModal, {
			title = v24,
			screenSize = v15,
			buttonStackProps = buttonConfig,
			onCloseClicked = v21 and t1.closeModal,
			distanceFromTop = StatusBarSizeY,
			footerContent = footerContent
		}, {
			Middle = React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				ContentPadding = React.createElement("UIPadding", {
					PaddingBottom = buttonConfig and UDim.new(0, DEFAULT_PADDING),
					PaddingTop = UDim.new(0, DEFAULT_PADDING)
				}),
				ListLayout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, DEFAULT_PADDING),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				BodyFragment = makeBodyFragment(v16)
			})
		})
	end)
end
