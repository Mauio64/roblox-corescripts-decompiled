local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images
local t = require(CorePackages.Packages.t)

local module = require("@luauforge/deferred/hXF")

game:DefineFastInt("AuthFailureMaxRetryDelay", 300)

local extended = Roact.PureComponent:extend("AccountAuthenticationFailureOverlay")

extended.validateProps = t.interface({
	onActivated = t.callback,
	screenSize = t.Vector2
})

local function getDelay(p2)
	return (math.min(2 ^ p2, game:GetFastInt("AuthFailureMaxRetryDelay")))
end

function extended:init()
	self.state = { countdownStarted = false, secondsRemaining = nil }

	self.timesRetried = 0

	function self.onRetry()
		self:setState({ countdownStarted = true })
	end
end

function extended:didUpdate(p2, p3)
	if self.state.countdownStarted and not p3.countdownStarted then
		self:_onRetry()
	end
end

function extended:_onRetry()
	self.props.onActivated()
	self.timesRetried += 1

	local lastTime = tick()
	local v5 = math.min(2 ^ self.timesRetried, game:GetFastInt("AuthFailureMaxRetryDelay"))
	local function countDown()
		if self.isMounted then
			local v7 = v5 - (tick() - lastTime)

			if v7 > 0 then
				self:setState({ secondsRemaining = math.round(v7) })

				task.delay(1, countDown)
			else
				self:setState({
					countdownStarted = false,
					secondsRemaining = Roact.None
				})
			end
		end
	end
	countDown()
end

function extended.render(data)
	local v5, v6

	if module() then
		v5 = "Authentication.Login.Action.ConnectionError.RetryReady"
		v6 = "Authentication.Login.Label.ConnectionError.RetryDisabled"
	elseif data.state.countdownStarted then
		v5 = "Authentication.Login.Action.ConnectionError.RetryWait"
		v6 = "Authentication.Login.Label.ConnectionError.RetryWait"
	else
		v5 = "Authentication.Login.Action.ConnectionError.RetryReady"
		v6 = "Authentication.Login.Label.ConnectionError.RetryReady"
	end

	return withLocalization({
		titleText = "Authentication.Login.Label.ConnectionError.Title",
		retryButtonText = v5,
		bodyText = v6
	})(function(props)
		return Roact.createElement(interactiveAlert, {
			title = props.titleText,
			bodyText = props.bodyText,
			titleIcon = images["icons/status/error_large"],
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							isDisabled = data.state.countdownStarted or module(),
							onActivated = data.onRetry,
							text = string.gsub(
								props.retryButtonText,
								"{.-}",
								data.state.secondsRemaining or ""
							)
						}
					}
				}
			},
			screenSize = data.props.screenSize
		})
	end)
end

function extended:didMount()
	self.isMounted = true
end

function extended:willUnmount()
	self.isMounted = false
end

local function mapStateToProps(p2, p3)
	return { screenSize = p2.ScreenSize }
end

return (RoactRodux.connect(mapStateToProps)(extended))
