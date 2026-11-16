local module = require("@luauforge/bundled/gaZ")

local roact = module.Roact
local shareLinksRodux = module.ShareLinksRodux
local uiBlox = module.UIBlox
local foundation = module.Foundation
local iconSize = foundation.Enums.IconSize
local loading = foundation.Loading

local t = module.t
local withLocalization = module.withLocalization

local experienceInviteStatus = shareLinksRodux.Enums.ExperienceInviteStatus
local buttonType = uiBlox.App.Button.Enum.ButtonType
local interactiveAlert = uiBlox.App.Dialog.Alert.InteractiveAlert

local extended = roact.Component:extend("InviteLinkExpiredModal")
require("@luauforge/bundled/gbo")

extended.defaultProps = {
	closeModal = function() end,
	launchGame = function() end
}

extended.validateProps = t.interface({
	closeModal = t.callback,
	launchGame = t.callback,
	linkStatus = t.string,
	experienceName = t.string,
	isLoading = t.boolean,
	screenSize = t.Vector2
})

function extended.render(p2)
	local props = p2.props
	local v5, v6

	if experienceInviteStatus.fromRawValue(props.linkStatus) == experienceInviteStatus.InviterNotInExperience then
		v5 = "Feature.SocialShare.Label.InviterNotHereError"
		v6 = "Feature.SocialShare.Description.InviterNotHereError"
	else
		v5 = "Feature.SocialShare.Label.InviteExpiredError"
		v6 = "Feature.SocialShare.Description.InviteExpiredError"
	end

	return withLocalization({
		titleText = v5,
		bodyText = {
			v6,
			experienceName = props.experienceName
		},
		confirmButtonText = "Feature.Chat.Drawer.Join",
		cancelButtonText = "Feature.Friends.Label.Cancel"
	})(function(props2)
		local function fn()
			return roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1 },
				{
					Spinner = roact.createElement(loading, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						size = iconSize.Large
					})
				}
			)
		end

		local createElement = roact.createElement
		local v8 = {
			screenSize = props.screenSize,
			title = props2.titleText,
			bodyText = 0,
			middleContent = 0,
			buttonStackInfo = 0
		}
		local v9 = if not props.isLoading then props2.bodyText else nil
		v8.bodyText = v9
		v8.middleContent = props.isLoading and fn or nil
		v8.buttonStackInfo = {
			buttons = {
				{
					buttonType = nil,
					props = {
						text = props2.cancelButtonText,
						onActivated = function()
							props.closeModal(false)
						end
					}
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						text = props2.confirmButtonText,
						onActivated = function()
							props.launchGame()
							props.closeModal(true)
						end
					}
				}
			}
		}
		return createElement(interactiveAlert, v8)
	end)
end

return extended
