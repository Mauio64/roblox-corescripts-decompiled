local scriptParent = script.Parent
local dependencies = require(scriptParent.dependencies)
local Roact = dependencies.Roact
local ShareLinksRodux = dependencies.ShareLinksRodux
local UIBlox = dependencies.UIBlox
local Foundation = dependencies.Foundation
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local t = dependencies.t
local withLocalization = dependencies.withLocalization
local ExperienceInviteStatus = ShareLinksRodux.Enums.ExperienceInviteStatus
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local v14 = Roact.Component:extend("InviteLinkExpiredModal")

require(script.Parent.inviteLinkExpiredMapStateToProps)
v14.defaultProps = {
	closeModal = function() -- line: 31
	end,
	launchGame = function() -- line: 32
	end
}
v14.validateProps = t.interface({
	closeModal = t.callback,
	launchGame = t.callback,
	linkStatus = t.string,
	experienceName = t.string,
	isLoading = t.boolean,
	screenSize = t.Vector2
})

function v14.render(p1) -- line: 46
	-- upvalues: ExperienceInviteStatus (copy), withLocalization (copy), Roact (copy), Loading (copy), IconSize (copy), InteractiveAlert (copy), ButtonType (copy)
	local props = p1.props
	local s1, s2

	if ExperienceInviteStatus.fromRawValue(props.linkStatus) == ExperienceInviteStatus.InviterNotInExperience then
		s1 = "Feature.SocialShare.Label.InviterNotHereError"
		s2 = "Feature.SocialShare.Description.InviterNotHereError"
	else
		s1 = "Feature.SocialShare.Label.InviteExpiredError"
		s2 = "Feature.SocialShare.Description.InviteExpiredError"
	end

	return withLocalization({
		confirmButtonText = "Feature.Chat.Drawer.Join",
		cancelButtonText = "Feature.Friends.Label.Cancel",
		titleText = s1,
		bodyText = {
			s2,
			experienceName = props.experienceName
		}
	})(function(p2) -- line: 67
		-- upvalues: Roact (copy), Loading (copy), IconSize (copy), InteractiveAlert (copy), props (copy), ButtonType (copy)
		return Roact.createElement(InteractiveAlert, {
			screenSize = props.screenSize,
			title = p2.titleText,
			bodyText = if props.isLoading then nil else p2.bodyText,
			middleContent = props.isLoading and function() -- line: 68
				-- upvalues: Roact (copy), Loading (copy), IconSize (copy)
				return Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 48)
				}, {
					Spinner = Roact.createElement(Loading, {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						size = IconSize.Large
					})
				})
			end or nil,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = nil,
						props = {
							text = p2.cancelButtonText,
							onActivated = function() -- line: 92
								-- upvalues: props (copy)
								props.closeModal(false)
							end
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							text = p2.confirmButtonText,
							onActivated = function() -- line: 101
								-- upvalues: props (copy)
								props.launchGame()
								props.closeModal(true)
							end
						}
					}
				}
			}
		})
	end)
end

return v14
