local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local t = require(CorePackages.Packages.t)
local GetFFlagDisableAuthFailureRetry = require(Modules.LuaApp.Flags.GetFFlagDisableAuthFailureRetry)

game:DefineFastInt("AuthFailureMaxRetryDelay", 300)

local v12 = Roact.PureComponent:extend("AccountAuthenticationFailureOverlay")

v12.validateProps = t.interface({
	onActivated = t.callback,
	screenSize = t.Vector2
})

local function getDelay(p1) -- line: 27
	return (math.min(2 ^ p1, game:GetFastInt("AuthFailureMaxRetryDelay")))
end

function v12.init(p2) -- line: 31
	p2.state = {
		countdownStarted = false,
		secondsRemaining = nil
	}
	p2.timesRetried = 0

	function p2.onRetry() -- line: 39
		-- upvalues: p2 (copy)
		p2:setState({
			countdownStarted = true
		})
	end
end
function v12.didUpdate(p3, _, p5) -- line: 46
	if p3.state.countdownStarted and not p5.countdownStarted then
		p3:_onRetry()
	end
end
function v12._onRetry(p6) -- line: 52
	-- upvalues: Roact (copy)
	p6.props.onActivated()
	p6.timesRetried = p6.timesRetried + 1

	local timestamp = tick()
	local v22 = math.min(2 ^ p6.timesRetried, game:GetFastInt("AuthFailureMaxRetryDelay"))

	local function countDown() -- line: 59
		-- upvalues: p6 (copy), timestamp (copy), v22 (copy), countDown (copy), Roact (copy)
		if p6.isMounted then
			local v31 = tick() - timestamp
			local v32 = v22 - v31

			if v32 > 0 then
				p6:setState({
					secondsRemaining = math.round(v32)
				})
				task.delay(1, countDown)

				return
			end

			p6:setState({
				countdownStarted = false,
				secondsRemaining = Roact.None
			})
		end
	end

	countDown()
end
function v12.render(p7) -- line: 80
	-- upvalues: GetFFlagDisableAuthFailureRetry (copy), withLocalization (copy), Roact (copy), InteractiveAlert (copy), Images (copy), ButtonType (copy)
	local s1, s2

	if GetFFlagDisableAuthFailureRetry() then
		s1 = "Authentication.Login.Action.ConnectionError.RetryReady"
		s2 = "Authentication.Login.Label.ConnectionError.RetryDisabled"
	elseif p7.state.countdownStarted then
		s1 = "Authentication.Login.Action.ConnectionError.RetryWait"
		s2 = "Authentication.Login.Label.ConnectionError.RetryWait"
	else
		s1 = "Authentication.Login.Action.ConnectionError.RetryReady"
		s2 = "Authentication.Login.Label.ConnectionError.RetryReady"
	end

	return withLocalization({
		titleText = "Authentication.Login.Label.ConnectionError.Title",
		retryButtonText = s1,
		bodyText = s2
	})(function(p8) -- line: 96
		-- upvalues: Roact (copy), InteractiveAlert (copy), Images (copy), ButtonType (copy), p7 (copy), GetFFlagDisableAuthFailureRetry (copy)
		return Roact.createElement(InteractiveAlert, {
			title = p8.titleText,
			bodyText = p8.bodyText,
			titleIcon = Images["icons/status/error_large"],
			buttonStackInfo = {
				buttons = {{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = p7.state.countdownStarted or GetFFlagDisableAuthFailureRetry(),
						onActivated = p7.onRetry,
						text = string.gsub(p8.retryButtonText, "{.-}", p7.state.secondsRemaining or "")
					}
				}}
			},
			screenSize = p7.props.screenSize
		})
	end)
end
function v12.didMount(p9) -- line: 118
	p9.isMounted = true
end
function v12.willUnmount(p10) -- line: 122
	p10.isMounted = false
end

local function mapStateToProps(p11, _) -- line: 126
	return {
		screenSize = p11.ScreenSize
	}
end

return (RoactRodux.connect(mapStateToProps)(v12))
