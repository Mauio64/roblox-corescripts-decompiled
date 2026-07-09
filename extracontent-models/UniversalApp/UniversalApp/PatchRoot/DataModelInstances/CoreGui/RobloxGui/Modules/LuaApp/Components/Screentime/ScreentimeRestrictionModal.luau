local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval
local UIBlox = require(CorePackages.Packages.UIBlox)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useStyle = UIBlox.Core.Style.useStyle
local ApiFetchAccessStatus = require(Modules.LuaApp.Thunks.Moderation.ApiFetchAccessStatus)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Constants = require(Modules.LuaApp.Constants)
local getScreenBottomInset = require(Modules.LuaApp.getScreenBottomInset)
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local ScreentimeRestrictionOptionsModal = require(script.Parent.ScreentimeRestrictionOptionsModal)
local ScreentimeRestrictionErrorModal = require(script.Parent.ScreentimeRestrictionErrorModal)
local ScreentimeRestrictionLoadingSpinner = require(script.Parent.ScreentimeRestrictionLoadingSpinner)
local AddTemporaryScreentime = require(Modules.LuaApp.Http.Requests.AddTemporaryScreentime)
local v24 = game:DefineFastInt("ParentalControlsScreentimeLockoutPollIntervalMs", 15000)
local FFlagEnableScreentimeMoreTimeOption = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableScreentimeMoreTimeOption

local function getAddMoreTimeButtonStackProps(s1: string, b1: boolean, p1) -- line: 46
	-- upvalues: ButtonType (copy)
	local t1 = {{
		buttonType = ButtonType.Secondary,
		props = {
			isDisabled = false,
			onActivated = function() -- line: 52
				-- upvalues: p1 (copy)
				p1()
			end,
			text = s1
		}
	}}
	local t2 = {
		buttonHeight = 48,
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = t1
	}

	if b1 then
		return t2
	end

	return nil
end

local v27 = not FFlagEnableScreentimeMoreTimeOption and function(t3: {[any]: any}) -- line: 218
	-- upvalues: useLocalization (copy), useStyle (copy), getScreenBottomInset (copy), React (copy), v24 (copy), setInterval (copy), clearInterval (copy), PartialPageModal (copy), Constants (copy)
	local v50 = useLocalization({
		CloseText = "CommonUI.Controls.Action.CloseRoblox",
		TitleText = "Feature.Screentime.Heading.ScreentimeLimitDialog",
		BodyText = "Feature.Screentime.Content.ScreentimeLimitDialog"
	})
	local screenSize = t3.screenSize
	local v52 = useStyle()
	local Theme = v52.Theme
	local Font = v52.Font
	local globalGuiInset = t3.globalGuiInset
	local v56 = getScreenBottomInset()
	local uDim2 = UDim2.fromOffset(0, globalGuiInset.top)
	local uDim2_2 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - v56)

	React.useEffect(function() -- line: 236
		-- upvalues: v24 (copy), setInterval (copy), t3 (copy), clearInterval (copy)
		local v68 = v24
		local v69 = setInterval(function() -- line: 238
			-- upvalues: t3 (copy)
			t3.fetchUserAccess(t3.networking)
		end, v68)

		return function() -- line: 242
			-- upvalues: v69 (copy), clearInterval (copy)
			if v69 then
				clearInterval(v69)
			end
		end
	end, {})

	local v59 = React.createElement(PartialPageModal, {
		title = v50.TitleText,
		screenSize = screenSize
	}, {
		Body = React.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, 60),
			BackgroundColor3 = Theme.BackgroundUIDefault.Color
		}, {
			CustomInner = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextScaled = true,
				Text = v50.BodyText,
				TextColor3 = Theme.TextDefault.Color,
				TextXAlignment = Enum.TextXAlignment.Center,
				Font = Font.Body.Font,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				UITextSizeConstraint = React.createElement("UITextSizeConstraint", {
					MaxTextSize = Font.BaseSize * Font.Body.RelativeSize
				})
			})
		})
	})

	if t3.userAccess ~= nil then
		return React.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = Constants.DisplayOrder.AntiAddictionPrompt
		}, {
			OverlayFrame = React.createElement("ImageButton", {
				AutoButtonColor = false,
				ImageTransparency = 1,
				BorderSizePixel = 0,
				Selectable = false,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Theme.Overlay.Color,
				BackgroundTransparency = Theme.Overlay.Transparency
			}, {
				Overlay = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = uDim2,
					Size = uDim2_2
				}, {
					Content = v59
				})
			})
		})
	end

	return nil
end or function(t4: {[any]: any}) -- line: 76
	-- upvalues: useLocalization (copy), useStyle (copy), getScreenBottomInset (copy), FFlagEnableScreentimeMoreTimeOption (copy), useAppPolicy (copy), React (copy), v24 (copy), setInterval (copy), clearInterval (copy), InteractiveAlert (copy), getAddMoreTimeButtonStackProps (copy), ScreentimeRestrictionLoadingSpinner (copy), ScreentimeRestrictionOptionsModal (copy), AddTemporaryScreentime (copy), ScreentimeRestrictionErrorModal (copy), Constants (copy)
	local v35 = useLocalization({
		CloseText = "CommonUI.Controls.Action.CloseRoblox",
		TitleText = "Feature.Screentime.Heading.ScreentimeLimitDialog",
		BodyText = "Feature.Screentime.Content.ScreentimeLimitDialog",
		AddMoreTimeText = "Feature.Screentime.Label.Options"
	})
	local screenSize = t4.screenSize
	local Theme = useStyle().Theme
	local globalGuiInset = t4.globalGuiInset
	local v39 = getScreenBottomInset()
	local uDim2 = UDim2.fromOffset(0, globalGuiInset.top)
	local uDim2_3 = UDim2.fromOffset(screenSize.X, screenSize.Y - globalGuiInset.top - v39)
	local v42 = false

	if FFlagEnableScreentimeMoreTimeOption then
		v42 = useAppPolicy(function(p2) -- line: 93
			return p2.getScreentimeMoreTimeOptionEnabled()
		end)
	end

	local _ = {
		RestrictionModal = 1,
		AddTimeModal = 2,
		RetryModal = 3,
		ErrorModal = 4,
		UnlockedAndWaiting = 5
	}
	local v44, v45 = React.useState(1)
	local v46, v47 = React.useState(0)

	React.useEffect(function() -- line: 109
		-- upvalues: v24 (copy), setInterval (copy), t4 (copy), clearInterval (copy)
		local v64 = v24
		local v65 = setInterval(function() -- line: 111
			-- upvalues: t4 (copy)
			t4.fetchUserAccess(t4.networking)
		end, v64)

		return function() -- line: 115
			-- upvalues: v65 (copy), clearInterval (copy)
			if v65 then
				clearInterval(v65)
			end
		end
	end, {})

	local v48 = React.createElement(InteractiveAlert, {
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = screenSize,
		title = v35.TitleText,
		bodyText = v35.BodyText,
		buttonStackInfo = getAddMoreTimeButtonStackProps(v35.AddMoreTimeText, v42, function(_) -- line: 131
			-- upvalues: v45 (copy)
			v45(2)
		end)
	})

	if t4.userAccess ~= nil then
		if v44 == 5 then
			return React.createElement(ScreentimeRestrictionLoadingSpinner, {
				screenSize = screenSize,
				globalGuiInset = globalGuiInset
			})
		end

		if v44 == 2 then
			return React.createElement(ScreentimeRestrictionOptionsModal, {
				screenSize = screenSize,
				globalGuiInset = globalGuiInset,
				onClose = function() -- line: 148
					-- upvalues: v45 (copy)
					v45(1)
				end,
				onAddTime = function(p4) -- line: 151
					-- upvalues: AddTemporaryScreentime (copy), t4 (copy), v45 (copy), v47 (copy)
					AddTemporaryScreentime(t4.networking, p4):andThen(function() -- line: 152
						-- upvalues: v45 (copy)
						v45(5)
					end):catch(function() -- line: 154
						-- upvalues: v47 (copy), p4 (copy), v45 (copy)
						v47(p4)
						v45(3)
					end)
				end
			})
		end

		if v44 == 3 then
			return React.createElement(ScreentimeRestrictionErrorModal, {
				screenSize = screenSize,
				globalGuiInset = globalGuiInset,
				onClose = function() -- line: 165
					-- upvalues: v45 (copy)
					v45(1)
				end,
				onRetry = function() -- line: 168
					-- upvalues: AddTemporaryScreentime (copy), t4 (copy), v46 (copy), v45 (copy)
					AddTemporaryScreentime(t4.networking, v46):andThen(function() -- line: 169
						-- upvalues: v45 (copy)
						v45(5)
					end):catch(function() -- line: 171
						-- upvalues: v45 (copy)
						v45(4)
					end)
				end
			})
		end

		if v44 == 4 then
			return React.createElement(ScreentimeRestrictionErrorModal, {
				screenSize = screenSize,
				globalGuiInset = globalGuiInset,
				onClose = function() -- line: 181
					-- upvalues: v45 (copy)
					v45(1)
				end
			})
		end

		return React.createElement("ScreenGui", {
			IgnoreGuiInset = true,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			DisplayOrder = Constants.DisplayOrder.AntiAddictionPrompt
		}, {
			OverlayFrame = React.createElement("ImageButton", {
				AutoButtonColor = false,
				ImageTransparency = 1,
				BorderSizePixel = 0,
				Selectable = false,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Theme.Overlay.Color,
				BackgroundTransparency = Theme.Overlay.Transparency
			}, {
				Overlay = React.createElement("Frame", {
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					Position = uDim2,
					Size = uDim2_3
				}, {
					Content = v48
				})
			})
		})
	end

	return nil
end
local v28 = RoactRodux.connect(function(p5, _) -- line: 307
	return {
		userAccess = p5.UserAccess,
		restrictionDetail = p5.UserAccess and p5.UserAccess.restrictionDetail or nil
	}
end, function(p7) -- line: 312
	-- upvalues: ApiFetchAccessStatus (copy)
	return {
		fetchUserAccess = function(p8) -- line: 314
			-- upvalues: p7 (copy), ApiFetchAccessStatus (copy)
			p7(ApiFetchAccessStatus(p8))
		end
	}
end)(v27)

return (RoactServices.connect({
	networking = RoactNetworking
})(v28))
