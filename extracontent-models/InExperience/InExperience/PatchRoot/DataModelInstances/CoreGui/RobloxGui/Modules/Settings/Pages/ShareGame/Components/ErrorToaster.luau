local CorePackages = game:GetService("CorePackages")
local RunService = game:GetService("RunService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RobloxGui = game:GetService("CoreGui"):WaitForChild("RobloxGui")
local ShareGame = RobloxGui.Modules.Settings.Pages.ShareGame
local Constants = require(ShareGame.Constants)
local StoppedToastTimer = require(ShareGame.Actions.StoppedToastTimer)
local Theme = require(RobloxGui.Modules.Settings.Theme)
local InviteStatus = Constants.InviteStatus
local v11 = require(ShareGame.getTranslator)()
local v12 = Roact.PureComponent:extend("ErrorToaster")

function v12.restartTimer(p1) -- line: 26
	-- upvalues: RunService (copy)
	if not p1.timerConnection then
		p1.timerConnection = RunService.RenderStepped:Connect(function() -- line: 28
			-- upvalues: p1 (copy)
			local failedInvites = p1.props.failedInvites

			if #failedInvites == 0 then
				p1:stopTimer()

				return
			end

			if failedInvites[#failedInvites].timeStamp + 4 < tick() then
				p1:stopTimer()
			end
		end)
	end
end
function v12.stopTimer(p2) -- line: 47
	if p2.timerConnection then
		p2.timerConnection:Disconnect()
		p2.timerConnection = nil
	end

	p2.props.stoppedTimerDispatch()
end
function v12.didUpdate(p3) -- line: 56
	if #p3.props.failedInvites ~= 0 then
		p3:restartTimer()
	end
end
function v12.render(p4) -- line: 64
	-- upvalues: Constants (copy), InviteStatus (copy), Roact (copy), Theme (copy), v11 (copy)
	local deviceLayout = p4.props.deviceLayout
	local failedInvites = p4.props.failedInvites
	local TOAST_HEIGHT = Constants.LayoutSpecific[deviceLayout].TOAST_HEIGHT

	if #failedInvites == 0 then
		return
	end

	local status = failedInvites[#failedInvites].status
	local s1

	if status == InviteStatus.Moderated then
		s1 = "Feature.SettingsHub.Label.ModeratedInviteError"
	else
		if status ~= InviteStatus.Failed then
			return
		end

		s1 = "Feature.SettingsHub.Label.GameInviteError"
	end

	return Roact.createElement("ScreenGui", {
		DisplayOrder = 2,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		ToastFrame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundColor3 = Constants.Color.RED,
			Position = UDim2.new(0.5, 0, 0, 0),
			Size = UDim2.new(0.5, 0, 0, TOAST_HEIGHT)
		}, {
			InnerTextPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 6),
				PaddingRight = UDim.new(0, 6)
			}),
			ToastText = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextWrapped = true,
				Font = Theme.font(Enum.Font.SourceSansSemibold, "Semibold"),
				Size = UDim2.new(1, 0, 1, 0),
				Text = v11:FormatByKey(s1),
				TextColor3 = Constants.Color.WHITE,
				TextSize = Theme.textSize(16)
			})
		})
	})
end

local function mapStateToProps(p5) -- line: 113
	return {
		deviceLayout = p5.DeviceInfo.DeviceLayout,
		failedInvites = p5.Toasts.failedInvites
	}
end
local function mapDispatchToProps(p6) -- line: 120
	-- upvalues: StoppedToastTimer (copy)
	return {
		stoppedTimerDispatch = function() -- line: 122
			-- upvalues: p6 (copy), StoppedToastTimer (copy)
			p6(StoppedToastTimer())
		end
	}
end

return RoactRodux.UNSTABLE_connect2(mapStateToProps, mapDispatchToProps)(v12)
