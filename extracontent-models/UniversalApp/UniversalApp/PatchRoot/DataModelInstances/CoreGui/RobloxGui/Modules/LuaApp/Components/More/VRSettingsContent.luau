local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local React = require(CorePackages.Packages.React)
local Roact = require(CorePackages.Packages.Roact)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local LinkButton = UIBlox.App.Button.LinkButton
local OpenCentralOverlayForLeaveRobloxAlert = require(Modules.LuaApp.Thunks.OpenCentralOverlayForLeaveRobloxAlert)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local DeviceSettingsPageContent = require(Modules.LuaApp.Components.More.DeviceSettings.DeviceSettingsPageContent)

local function Divider(p1) -- line: 21
	-- upvalues: React (copy)
	local style = p1.style

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = style.Theme.Divider.Color,
		BackgroundTransparency = style.Theme.Divider.Transparency,
		LayoutOrder = p1.layoutOrder
	})
end
local function VRSettingsContent(p2) -- line: 32
	-- upvalues: Roact (copy), useStyle (copy), useLocalization (copy), React (copy), LinkButton (copy), Divider (copy), DeviceSettingsPageContent (copy)
	local v22 = Roact.createRef()
	local v23 = useStyle()
	local v24 = useLocalization({
		accountSettings = "Application.Settings.AccountSettingsTitle",
		accountSettingsSubtitle = "Application.Settings.VRAccountSettingsSubtitle",
		accountSettingsExplanation = "Application.Settings.VRAccountSettingsExplanation",
		appSettingsTitle = "Application.Settings.AppSettingsTitle",
		volumeSliderDescription = "Application.Settings.VolumeSliderDescription"
	})
	local BaseSize = v23.Font.BaseSize
	local v26 = BaseSize * v23.Font.Title.RelativeSize
	local v27 = BaseSize * v23.Font.Header2.RelativeSize
	local v28 = React.useCallback(function() -- line: 47
		-- upvalues: p2 (copy)
		p2.linking:openURL("https://www.roblox.com/my/account#!/info"):andThen(function(p3) -- line: 48
			-- upvalues: p2 (copy)
			if p3 == false then
				p2.linking:openURL("https://www.roblox.com/my/account#!/info")
			end
		end)
		p2.closeAlert()
	end, {
		p2.linking,
		p2.closeAlert
	})

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		LayoutOrder = 0,
		[Roact.Ref] = v22
	}, {
		Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			Padding = UDim.new(0, 30)
		}),
		AccountSettings = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 0,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 8)
			}),
			AccountSettingsTitle = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v24.accountSettings,
				Font = v23.Font.Title.Font,
				TextSize = v26,
				TextColor3 = v23.Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Left
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 10)
				})
			}),
			AccountSettingsSubTitle = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v24.accountSettingsSubtitle,
				Font = v23.Font.Header2.Font,
				TextSize = v27,
				TextColor3 = v23.Theme.TextEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			AccessExplanation = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = v24.accountSettingsExplanation,
				Font = v23.Font.Title.Font,
				TextSize = BaseSize * v23.Font.Body.RelativeSize,
				TextColor3 = v23.Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Left
			}),
			Link = React.createElement("Frame", {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY
			}, React.createElement(LinkButton, {
				text = "https://www.roblox.com/my/account#!/info",
				minPaddingX = 0,
				minPaddingY = 0,
				onActivated = function() -- line: 129
					-- upvalues: p2 (copy), v28 (copy)
					p2.openLeaveRobloxAlertUIBlox(v28)
				end
			}))
		}),
		Divider1 = Divider({
			layoutOrder = 2,
			style = v23
		}),
		AppSettings = React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 8)
			}),
			AppSettingsTitle = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(1, 0, 0, 0),
				Text = v24.appSettingsTitle,
				Font = v23.Font.Title.Font,
				TextSize = v26,
				TextColor3 = v23.Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Left
			}, {
				UIPadding = React.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 10)
				})
			}),
			DeviceSettings = React.createElement(DeviceSettingsPageContent)
		})
	})
end

local v18 = RoactRodux.connect(nil, function(p4) -- line: 169
	-- upvalues: OpenCentralOverlayForLeaveRobloxAlert (copy), CloseCentralOverlay (copy)
	return {
		openLeaveRobloxAlertUIBlox = function(p5) -- line: 171
			-- upvalues: p4 (copy), OpenCentralOverlayForLeaveRobloxAlert (copy)
			p4(OpenCentralOverlayForLeaveRobloxAlert(p5))
		end,
		closeAlert = function() -- line: 174
			-- upvalues: p4 (copy), CloseCentralOverlay (copy)
			p4(CloseCentralOverlay())
		end
	}
end)(VRSettingsContent)

return RoactServices.connect({
	roactAnalytics = RoactAnalytics,
	linking = AppLinking
})(v18)
