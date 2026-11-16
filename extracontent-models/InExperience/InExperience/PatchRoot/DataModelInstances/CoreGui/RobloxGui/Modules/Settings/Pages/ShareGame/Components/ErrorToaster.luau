local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame

local Constants = require(ShareGame.Constants)
local StoppedToastTimer = require(ShareGame.Actions.StoppedToastTimer)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local InviteStatus = Constants.InviteStatus

local getTranslator = require(ShareGame.getTranslator)
local translator = getTranslator()

local extended = Roact.PureComponent:extend("ErrorToaster")

function extended:restartTimer()
	if not self.timerConnection then
		self.timerConnection = RunService.RenderStepped:Connect(function()
			local failedInvites = self.props.failedInvites

			if #failedInvites == 0 then
				self:stopTimer()
			elseif failedInvites[#failedInvites].timeStamp + 4 < tick() then
				self:stopTimer()
			end
		end)
	end
end

function extended:stopTimer()
	if self.timerConnection then
		self.timerConnection:Disconnect()
		self.timerConnection = nil
	end

	self.props.stoppedTimerDispatch()
end

function extended:didUpdate()
	if #self.props.failedInvites ~= 0 then
		self:restartTimer()
	end
end

function extended.render(p)
	local deviceLayout = p.props.deviceLayout
	local failedInvites = p.props.failedInvites

	local TOAST_HEIGHT = Constants.LayoutSpecific[deviceLayout].TOAST_HEIGHT

	if #failedInvites == 0 then
		return
	end

	local status = failedInvites[#failedInvites].status
	local v

	if status == InviteStatus.Moderated then
		v = "Feature.SettingsHub.Label.ModeratedInviteError"
		return Roact.createElement("ScreenGui", {
			DisplayOrder = 2,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			ToastFrame = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0),
				BackgroundColor3 = Constants.Color.RED,
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(0.5, 0, 0, TOAST_HEIGHT)
			}, {
				InnerTextPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, 6),
					PaddingRight = UDim.new(0, 6)
				}),
				ToastText = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold"),
					Size = UDim2.new(1, 0, 1, 0),
					Text = translator:FormatByKey(v),
					TextColor3 = Constants.Color.WHITE,
					TextSize = Theme.textSize(16),
					TextWrapped = true
				})
			})
		})
	end

	if status ~= InviteStatus.Failed then
		return
	end

	v = "Feature.SettingsHub.Label.GameInviteError"
	return Roact.createElement("ScreenGui", {
		DisplayOrder = 2,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		ToastFrame = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Constants.Color.RED,
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(0.5, 0, 0, TOAST_HEIGHT)
		}, {
			InnerTextPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6)
			}),
			ToastText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold"),
				Size = UDim2.new(1, 0, 1, 0),
				Text = translator:FormatByKey(v),
				TextColor3 = Constants.Color.WHITE,
				TextSize = Theme.textSize(16),
				TextWrapped = true
			})
		})
	})
end

local function mapStateToProps(p)
	return { deviceLayout = p.DeviceInfo.DeviceLayout, failedInvites = p.Toasts.failedInvites }
end

local function mapDispatchToProps(callback)
	return {
		stoppedTimerDispatch = function()
			callback(StoppedToastTimer())
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(extended)
