local _select = select

local function v257(tbl, idx, ...)
	local va = { ... }

	for i = 1, _select("#", ...) do
		tbl[idx + i - 1] = va[i]
	end
end

local ExperienceLoadingScript = script:FindFirstAncestor("ExperienceLoadingScript")
local ExperienceLoadingScriptParent = ExperienceLoadingScript.Parent
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local ExperienceService = game:GetService("ExperienceService")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local React = require(ExperienceLoadingScriptParent.React)
local InGameMenuDependencies = require(ExperienceLoadingScriptParent.InGameMenuDependencies)
local Cryo = InGameMenuDependencies.Cryo
local Roact = InGameMenuDependencies.Roact
local RoactRodux = InGameMenuDependencies.RoactRodux
local ExternalEventConnection = require(ExperienceLoadingScriptParent.RoactUtils).ExternalEventConnection
local GetGameProductInfo = require(ExperienceLoadingScript.Thunks.GetGameProductInfo)
local GetIsSubjectToChinaPolicies = require(ExperienceLoadingScript.Thunks.GetIsSubjectToChinaPolicies)
local GetUniverseId = require(ExperienceLoadingScript.Thunks.GetUniverseId)
local PlaceLauncherState = require(ExperienceLoadingScript.Enums.PlaceLauncherState)
local VerifiedBadges = require(ExperienceLoadingScriptParent.VerifiedBadges)
local LoggingProtocol = require(ExperienceLoadingScriptParent.LoggingProtocol)
local UIBlox = require(ExperienceLoadingScriptParent.UIBlox)
local FFlagIncreaseLoadingScreenOrder = require(ExperienceLoadingScriptParent.SharedFlags).FFlagIncreaseLoadingScreenOrder
local FFlagAddAutoTranslateToLoadingScreen = require(ExperienceLoadingScriptParent.SharedFlags).FFlagAddAutoTranslateToLoadingScreen
local FFlagAutoTranslateSkipZeroUniverseId = require(ExperienceLoadingScriptParent.SharedFlags).FFlagAutoTranslateSkipZeroUniverseId
local withStyle = UIBlox.Style.withStyle
local Responsive = require(ExperienceLoadingScriptParent.Responsive)
local Foundation = require(ExperienceLoadingScriptParent.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local FoundationProvider = Foundation.FoundationProvider
local Localization = require(ExperienceLoadingScriptParent.InExperienceLocales).Localization
local LocalizationProvider = require(ExperienceLoadingScriptParent.Localization).LocalizationProvider
local AutoTranslateBadge = require(ExperienceLoadingScript.Components.AutoTranslateBadge)
local LoadingScreenTelemetry = require(ExperienceLoadingScriptParent.ProgressLoading.LoadingScreenTelemetry)
local PolicyContainer = require(ExperienceLoadingScript.Components.PolicyContainer)
local ServerStatus = require(ExperienceLoadingScript.Components.ServerStatus)
local ServerStatusWithCountdown = require(ExperienceLoadingScript.Components.ServerStatusWithCountdown)
local v40 = Localization.new(LocalizationService.RobloxLocaleId)
local requestInternalWrapper = require(ExperienceLoadingScriptParent.Http).NetworkLayers.requestInternalWrapper
local QueueExperimentation = require(ExperienceLoadingScriptParent.SocialExperiments).QueueExperimentation
local GetFFlagReportFirstExperienceCancelled = require(ExperienceLoadingScript.Flags.GetFFlagReportFirstExperienceCancelled)
local v44 = if not FFlagAddAutoTranslateToLoadingScreen then requestInternalWrapper(HttpService) else require(ExperienceLoadingScript.createNetworking)
local n1 = 7

if FFlagIncreaseLoadingScreenOrder then
	n1 = 8
end

local vector2 = Vector2.new(768, 432)
local color3 = Color3.fromRGB(101, 102, 104)
local t1 = {
	MOBILE_PORTRAIT = {
		TOP = 44,
		BOTTOM = 44,
		LEFT = 24,
		RIGHT = 24
	},
	MOBILE_LANDSCAPE = {
		TOP = 24,
		BOTTOM = 24,
		LEFT = 44,
		RIGHT = 44
	},
	DESKTOP = {
		TOP = 24,
		BOTTOM = 24,
		LEFT = 24,
		RIGHT = 24
	},
	CONSOLE = {
		TOP = 64,
		BOTTOM = 64,
		LEFT = 64,
		RIGHT = 64
	}
}
local v49 = GuiService:IsTenFootInterface()
local Platform = UserInputService:GetPlatform()
local v51 = Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android
local t2 = {
	150,
	256
}
local u53 = nil
local n2 = 0
local n3 = 1e999

local function getPadding(p1) -- line: 101
	-- upvalues: v51 (copy), t1 (copy), v49 (copy)
	if v51 then
		return p1 and t1.MOBILE_PORTRAIT or t1.MOBILE_LANDSCAPE
	end

	if v49 then
		return t1.CONSOLE
	end

	return t1.DESKTOP
end
local function lerp(p2, p3) -- line: 111
	if type(p2) == "table" and #p2 >= 2 then
		local v65 = math.clamp(p3, 0, 1)

		return p2[1] * (1 - v65) + p2[2] * v65
	end

	return 0
end

local t9 = {
	FadeIn = function(p4, _, p6, p7) -- line: 120
		local t3 = {
			1,
			1
		}
		local t4 = {
			1,
			0
		}
		local t5 = {
			1,
			0.2
		}

		if p4 <= 0.6 then
			local v73 = p4 / 0.6
			local iconTransparency = p6.iconTransparency
			local v76

			if type(t4) == "table" and #t4 >= 2 then
				local v75 = math.clamp(v73, 0, 1)

				v76 = t4[1] * (1 - v75) + t4[2] * v75
			else
				v76 = 0
			end

			iconTransparency(v76)

			local iconSize = p6.iconSize
			local v79

			if type(t3) == "table" and #t3 >= 2 then
				local v78 = math.clamp(v73, 0, 1)

				v79 = t3[1] * (1 - v78) + t3[2] * v78
			else
				v79 = 0
			end

			iconSize(v79)

			local infoFrameTransparency = p6.infoFrameTransparency
			local v82

			if type(t5) == "table" and #t5 >= 2 then
				local v81 = math.clamp(v73, 0, 1)

				v82 = t5[1] * (1 - v81) + t5[2] * v81
			else
				v82 = 0
			end

			infoFrameTransparency(v82)

			local thumbnailTransparency = p6.thumbnailTransparency
			local v85

			if type(t4) == "table" and #t4 >= 2 then
				local v84 = math.clamp(v73, 0, 1)

				v85 = t4[1] * (1 - v84) + t4[2] * v84
			else
				v85 = 0
			end

			thumbnailTransparency(v85)

			local placeTextTransparency = p6.placeTextTransparency
			local v88

			if type(t4) == "table" and #t4 >= 2 then
				local v87 = math.clamp(v73, 0, 1)

				v88 = t4[1] * (1 - v87) + t4[2] * v87
			else
				v88 = 0
			end

			placeTextTransparency(v88)

			local placeTextSize = p6.placeTextSize
			local v91

			if type(t3) == "table" and #t3 >= 2 then
				local v90 = math.clamp(v73, 0, 1)

				v91 = t3[1] * (1 - v90) + t3[2] * v90
			else
				v91 = 0
			end

			placeTextSize(v91)

			local creatorTextTransparency = p6.creatorTextTransparency
			local v94

			if type(t4) == "table" and #t4 >= 2 then
				local v93 = math.clamp(v73, 0, 1)

				v94 = t4[1] * (1 - v93) + t4[2] * v93
			else
				v94 = 0
			end

			creatorTextTransparency(v94)

			local creatorTextSize = p6.creatorTextSize
			local v97

			if type(t3) == "table" and #t3 >= 2 then
				local v96 = math.clamp(v73, 0, 1)

				v97 = t3[1] * (1 - v96) + t3[2] * v96
			else
				v97 = 0
			end

			creatorTextSize(v97)

			return
		end

		p6.iconTransparency((type(t4) ~= "table" or not (#t4 >= 2)) and 0 or t4[1] * 0 + t4[2] * 1)
		p6.iconSize((type(t3) ~= "table" or not (#t3 >= 2)) and 0 or t3[1] * 0 + t3[2] * 1)
		p6.infoFrameTransparency((type(t5) ~= "table" or not (#t5 >= 2)) and 0 or t5[1] * 0 + t5[2] * 1)
		p6.thumbnailTransparency((type(t4) ~= "table" or not (#t4 >= 2)) and 0 or t4[1] * 0 + t4[2] * 1)
		p6.placeTextTransparency((type(t4) ~= "table" or not (#t4 >= 2)) and 0 or t4[1] * 0 + t4[2] * 1)
		p6.placeTextSize((type(t3) ~= "table" or not (#t3 >= 2)) and 0 or t3[1] * 0 + t3[2] * 1)
		p6.creatorTextTransparency((type(t4) ~= "table" or not (#t4 >= 2)) and 0 or t4[1] * 0 + t4[2] * 1)
		p6.creatorTextSize((type(t3) ~= "table" or not (#t3 >= 2)) and 0 or t3[1] * 0 + t3[2] * 1)
		p7()
	end,
	FadeOut = function(p8, _, p10, p11) -- line: 149
		-- upvalues: RunService (copy)
		local t6 = {
			1,
			0.6
		}
		local t7 = {
			0,
			1
		}
		local t8 = {
			0.2,
			1
		}

		if p8 <= 0.6 then
			local v105 = p8 / 0.6
			local iconTransparency = p10.iconTransparency
			local v108

			if type(t7) == "table" and #t7 >= 2 then
				local v107 = math.clamp(v105, 0, 1)

				v108 = t7[1] * (1 - v107) + t7[2] * v107
			else
				v108 = 0
			end

			iconTransparency(v108)

			local iconSize = p10.iconSize
			local v111

			if type(t6) == "table" and #t6 >= 2 then
				local v110 = math.clamp(v105, 0, 1)

				v111 = t6[1] * (1 - v110) + t6[2] * v110
			else
				v111 = 0
			end

			iconSize(v111)

			local infoFrameTransparency = p10.infoFrameTransparency
			local v114

			if type(t8) == "table" and #t8 >= 2 then
				local v113 = math.clamp(v105, 0, 1)

				v114 = t8[1] * (1 - v113) + t8[2] * v113
			else
				v114 = 0
			end

			infoFrameTransparency(v114)

			local thumbnailTransparency = p10.thumbnailTransparency
			local v117

			if type(t7) == "table" and #t7 >= 2 then
				local v116 = math.clamp(v105, 0, 1)

				v117 = t7[1] * (1 - v116) + t7[2] * v116
			else
				v117 = 0
			end

			thumbnailTransparency(v117)

			local placeTextTransparency = p10.placeTextTransparency
			local v120

			if type(t7) == "table" and #t7 >= 2 then
				local v119 = math.clamp(v105, 0, 1)

				v120 = t7[1] * (1 - v119) + t7[2] * v119
			else
				v120 = 0
			end

			placeTextTransparency(v120)

			local placeTextSize = p10.placeTextSize
			local v123

			if type(t6) == "table" and #t6 >= 2 then
				local v122 = math.clamp(v105, 0, 1)

				v123 = t6[1] * (1 - v122) + t6[2] * v122
			else
				v123 = 0
			end

			placeTextSize(v123)

			local creatorTextTransparency = p10.creatorTextTransparency
			local v126

			if type(t7) == "table" and #t7 >= 2 then
				local v125 = math.clamp(v105, 0, 1)

				v126 = t7[1] * (1 - v125) + t7[2] * v125
			else
				v126 = 0
			end

			creatorTextTransparency(v126)

			local creatorTextSize = p10.creatorTextSize
			local v129

			if type(t6) == "table" and #t6 >= 2 then
				local v128 = math.clamp(v105, 0, 1)

				v129 = t6[1] * (1 - v128) + t6[2] * v128
			else
				v129 = 0
			end

			creatorTextSize(v129)

			return
		end

		RunService:SetRobloxGuiFocused(false)
		p10.iconTransparency((type(t7) ~= "table" or not (#t7 >= 2)) and 0 or t7[1] * 0 + t7[2] * 1)
		p10.iconSize((type(t6) ~= "table" or not (#t6 >= 2)) and 0 or t6[1] * 0 + t6[2] * 1)
		p10.infoFrameTransparency((type(t8) ~= "table" or not (#t8 >= 2)) and 0 or t8[1] * 0 + t8[2] * 1)
		p10.thumbnailTransparency((type(t7) ~= "table" or not (#t7 >= 2)) and 0 or t7[1] * 0 + t7[2] * 1)
		p10.placeTextTransparency((type(t7) ~= "table" or not (#t7 >= 2)) and 0 or t7[1] * 0 + t7[2] * 1)
		p10.placeTextSize((type(t6) ~= "table" or not (#t6 >= 2)) and 0 or t6[1] * 0 + t6[2] * 1)
		p10.creatorTextTransparency((type(t7) ~= "table" or not (#t7 >= 2)) and 0 or t7[1] * 0 + t7[2] * 1)
		p10.creatorTextSize((type(t6) ~= "table" or not (#t6 >= 2)) and 0 or t6[1] * 0 + t6[2] * 1)
		p11()
	end
}

local function disconnectAndCloseHealthStat() -- line: 182
	-- upvalues: u53 (ref), GuiService (copy)
	if u53 then
		u53:disconnect()
		u53 = nil
		GuiService:CloseStatsBasedOnInputString("ConnectionHealth")
	end
end

local v60 = Roact.Component:extend("LoadingScreen")

function v60.playAnimation(p12, p13, p14, p15) -- line: 193
	-- upvalues: RunService (copy)
	p12.animationStartTime = tick()
	p12.animationFunction = p13

	if not p12.renderSteppedConnection then
		p12.renderSteppedConnection = RunService.RenderStepped:Connect(function() -- line: 198
			-- upvalues: p12 (copy), p14 (copy), p15 (copy)
			p12.animationFunction(tick() - p12.animationStartTime, p14, p12.updateBindings, function() -- line: 199
				-- upvalues: p12 (copy), p15 (copy)
				p12:stopAnimation()

				if p15 then
					p15()
				end
			end)
		end)
	end
end
function v60.stopAnimation(p16) -- line: 209
	if p16.renderSteppedConnection then
		p16.renderSteppedConnection:Disconnect()
		p16.renderSteppedConnection = nil
	end
end
function v60.renderBackground(p17, p18) -- line: 216
	-- upvalues: Roact (copy), n1 (ref), ExternalEventConnection (copy), RunService (copy)
	local thumbnailScaledWidth = p17.state.thumbnailScaledWidth
	local thumbnailScaledHeight = p17.state.thumbnailScaledHeight
	local thumbnailPositionX = p17.state.thumbnailPositionX
	local s1 = ""

	if p17.props.placeId and p17.props.placeId > 0 then
		s1 = ("rbxthumb://type=GameThumbnail&id=%d&w=768&h=432"):format(p17.props.placeId)
	end

	local ReducedMotion = p18.Settings.ReducedMotion

	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		DisplayOrder = n1,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, { Roact.createElement("Frame", {
		Name = "BackgroundFrame",
		[Roact.Change.AbsoluteSize] = p17.onAbsoluteSizeChange,
		BackgroundColor3 = p18.Theme.BackgroundUIDefault.Color,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Active = true
	}, {
		ThumbnailImage = Roact.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = s1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(thumbnailPositionX, 0.5),
			Size = UDim2.fromOffset(thumbnailScaledWidth, thumbnailScaledHeight),
			ImageTransparency = p17.bindings.thumbnailTransparency
		}),
		renderStepped = not ReducedMotion and Roact.createElement(ExternalEventConnection, {
			event = RunService.renderStepped,
			callback = p17.renderBackgroundSteppedCallback
		})
	}) })
end
function v60.showConnnectionHealthDebugMenu(_, _) -- line: 258
	-- upvalues: n2 (ref), n3 (ref), v51 (copy), GuiService (copy)
	if n2 == 0 then
		n2 = 1
		n3 = tick()

		return
	end

	if v51 and tick() - n3 <= 0.5 then
		GuiService:ShowStatsBasedOnInputString("ConnectionHealth")
	end

	n2 = 0
	n3 = 1e999
end
function v60.renderPlaceIcon(p21, p22) -- line: 275
	-- upvalues: Roact (copy), color3 (copy), ExternalEventConnection (copy), RunService (copy)
	local shimPos = p21.state.shimPos
	local v147 = p21.bindings.iconTransparency:getValue()
	local s2 = ""

	if p21.props.universeId and p21.props.universeId > 0 then
		s2 = ("rbxthumb://type=GameIcon&id=%d&w=256&h=256"):format(p21.props.universeId)
	end

	local ReducedMotion = p22.Settings.ReducedMotion
	local createElement = Roact.createElement
	local t10 = {
		Name = "IconFrame",
		BorderSizePixel = 0,
		Active = true,
		BackgroundTransparency = p21.bindings.iconTransparency,
		BackgroundColor3 = color3,
		Size = p21.bindings.iconSize,
		Position = UDim2.fromScale(0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5)
	}
	local t11 = {}
	local v153 = not ReducedMotion

	if v153 then
		local createElement2 = Roact.createElement
		local t12 = {
			BackgroundTransparency = 0,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1)
		}
		local t13 = {
			Corner = Roact.createElement("UICorner")
		}
		local createElement3 = Roact.createElement
		local t14 = {
			Rotation = 25,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0.5, 0.5, 0.5)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5))
			})
		}
		local new = NumberSequence.new
		local t15 = {}
		local new2 = NumberSequenceKeypoint.new
		local t16 = {
			0.7,
			1
		}
		local v164

		if type(t16) == "table" and #t16 >= 2 then
			local v163 = math.clamp(v147, 0, 1)

			v164 = t16[1] * (1 - v163) + t16[2] * v163
		else
			v164 = 0
		end

		local v165 = new2(0, v164)
		local new3 = NumberSequenceKeypoint.new
		local t17 = {
			0.3,
			1
		}
		local v169

		if type(t17) == "table" and #t17 >= 2 then
			local v168 = math.clamp(v147, 0, 1)

			v169 = t17[1] * (1 - v168) + t17[2] * v168
		else
			v169 = 0
		end

		local v170 = new3(0.5, v169)
		local new4 = NumberSequenceKeypoint.new
		local t18 = {
			0.7,
			1
		}
		local v174

		if type(t18) == "table" and #t18 >= 2 then
			local v173 = math.clamp(v147, 0, 1)

			v174 = t18[1] * (1 - v173) + t18[2] * v173
		else
			v174 = 0
		end

		t15[1] = v165
		t15[2] = v170
		v257(t15, 3, new4(1, v174))
		t14.Transparency = new(t15)
		t14.Offset = Vector2.new(shimPos, 0)
		t13.Gradient = createElement3("UIGradient", t14)
		t13.renderStepped = Roact.createElement(ExternalEventConnection, {
			event = RunService.renderStepped,
			callback = p21.renderShimmerCallback
		})
		v153 = createElement2("Frame", t12, t13)
	end

	t11.LoadingOverlay = v153
	t11.GameIconImage = Roact.createElement("ImageLabel", {
		BackgroundTransparency = 1,
		Image = s2,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		ImageTransparency = p21.bindings.iconTransparency
	}, {
		Corner = Roact.createElement("UICorner")
	})
	t11.Corner = Roact.createElement("UICorner")

	return createElement("Frame", t10, t11)
end
function v60.renderInfoFrame(p23, p24) -- line: 336
	-- upvalues: VerifiedBadges (copy), t2 (copy), Roact (copy), FFlagAddAutoTranslateToLoadingScreen (copy), v51 (copy)
	local productInfo = p23.props.productInfo
	local v178 = productInfo and productInfo.Name or ""
	local v179 = productInfo and productInfo.Creator.Name or ""

	if productInfo and productInfo.Creator.HasVerifiedBadge then
		v179 = VerifiedBadges.appendVerifiedBadge(v179)
	end

	local v180 = math.clamp(math.max(p23.state.absoluteSize.X, p23.state.absoluteSize.Y) / 1024 * t2[1], t2[1], t2[2])

	return Roact.createElement("Frame", {
		Name = "InfoFrame",
		BackgroundColor3 = p24.Theme.BackgroundMuted.Color,
		BackgroundTransparency = p23.bindings.infoFrameTransparency,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = p23.isPortrait and UDim2.fromScale(1, 0) or UDim2.fromScale(0.6, 0),
		Active = true,
		[Roact.Change.AbsoluteSize] = if not FFlagAddAutoTranslateToLoadingScreen then nil else function(p25) -- line: 360
			-- upvalues: p23 (copy)
			p23.updateBindings.updateInfoFrameAbsoluteSize(p25.AbsoluteSize)
		end
	}, {
		PlaceIcon = p23:renderPlaceIcon(p24),
		TextLayoutFrame = Roact.createElement("Frame", {
			Name = "TextLayout",
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Active = true,
			BackgroundColor3 = p24.Theme.BackgroundMuted.Color,
			AnchorPoint = Vector2.new(0.5, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0.5, 0, 0, v180 / 2),
			Size = UDim2.fromScale(1, 0)
		}, {
			PlaceLabel = Roact.createElement("TextLabel", {
				Name = "PlaceLabel",
				BackgroundTransparency = 1,
				TextScaled = false,
				TextWrapped = true,
				TextStrokeTransparency = 1,
				ZIndex = 2,
				LayoutOrder = 1,
				RichText = false,
				TextTransparency = p23.bindings.placeTextTransparency,
				Size = UDim2.fromScale(0.8, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = p24.Font.Title.Font,
				TextSize = p23.bindings.placeTextSize,
				TextColor3 = p24.Theme.TextEmphasis.Color,
				Text = v178,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			CreatorLabel = Roact.createElement("TextLabel", {
				Name = "CreatorLabel",
				BackgroundTransparency = 1,
				TextWrapped = true,
				TextScaled = false,
				TextStrokeTransparency = 1,
				ZIndex = 2,
				LayoutOrder = 2,
				RichText = false,
				TextTransparency = p23.bindings.creatorTextTransparency,
				Size = UDim2.fromScale(0.6, 0),
				AnchorPoint = Vector2.new(0.5, 1),
				AutomaticSize = Enum.AutomaticSize.Y,
				Font = p24.Font.CaptionBody.Font,
				TextSize = p23.bindings.creatorTextSize,
				TextColor3 = p24.Theme.TextDefault.Color,
				Text = v179,
				TextXAlignment = Enum.TextXAlignment.Center,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextTruncate = Enum.TextTruncate.AtEnd
			}),
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, not v51 and 36 or 12)
			}),
			Padding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, not v51 and 36 or 12),
				PaddingBottom = UDim.new(0, not v51 and 36 or 12)
			})
		}),
		Corner = Roact.createElement("UICorner")
	})
end
function v60.renderMain(p26, p27) -- line: 434
	-- upvalues: v51 (copy), t1 (copy), v49 (copy), Roact (copy), n1 (ref), Loading (copy), IconSize (copy), FFlagAddAutoTranslateToLoadingScreen (copy)
	local isPortrait = p26.isPortrait
	local v184 = if not v51 then if not v49 then t1.DESKTOP else t1.CONSOLE else isPortrait and t1.MOBILE_PORTRAIT or t1.MOBILE_LANDSCAPE
	local ReducedMotion = p27.Settings.ReducedMotion

	return Roact.createElement("ScreenGui", {
		IgnoreGuiInset = true,
		OnTopOfCoreBlur = true,
		DisplayOrder = n1 + 1,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}, {
		DarkGradient = Roact.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			Gradient = Roact.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
					ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
					ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(0.5, 1),
					NumberSequenceKeypoint.new(1, 0.5)
				})
			}),
			Spinner = ReducedMotion and Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				ZIndex = 20,
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.new(1, 1, 1)
			}, { Roact.createElement(Loading, {
				size = IconSize.Medium,
				Position = UDim2.new(1, 0, 1, 0),
				AnchorPoint = Vector2.new(1, 1)
			}) }),
			infoFrame = p26:renderInfoFrame(p27),
			AutoTranslate = FFlagAddAutoTranslateToLoadingScreen and p26:renderAutoTranslate() or nil,
			serverFrame = if p26.isQueueTreatmentEnabled then nil else p26:renderServerFrame(p27),
			policyContainer = if not p26.isQueueTreatmentEnabled then nil else p26:renderPolicyContainer(),
			serverStatusContainer = if not p26.isQueueTreatmentEnabled then nil else p26:renderServerStatus(),
			closeBtn = p26:renderCloseBtn(p27),
			gamepadCancelBtn = p26:renderGamepadCancelBtn(p27),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, v184.LEFT),
				PaddingRight = UDim.new(0, v184.RIGHT),
				PaddingTop = UDim.new(0, v184.TOP),
				PaddingBottom = UDim.new(0, v184.BOTTOM)
			})
		})
	})
end
function v60.renderCloseBtn(p28, _) -- line: 493
	-- upvalues: Responsive (copy), Roact (copy), GetFFlagReportFirstExperienceCancelled (copy), LoggingProtocol (copy)
	if p28.props.preferredInputRef.current ~= Responsive.Input.Directional and (not p28.state.showCloseBtn and tick() - p28.startTime > 5) then
		p28:setState({
			showCloseBtn = true
		})
	end

	return p28.state.showCloseBtn and Roact.createElement("ImageButton", {
		Name = "CloseButton",
		Image = "rbxasset://textures/loading/cancelButton.png",
		ImageTransparency = 0,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromOffset(not p28.isQueueTreatmentEnabled and 32 or 32, not p28.isQueueTreatmentEnabled and 32 or 32),
		Active = false,
		ZIndex = 10,
		[Roact.Event.MouseButton1Click] = function() -- line: 516
			-- upvalues: GetFFlagReportFirstExperienceCancelled (copy), LoggingProtocol (copy)
			if GetFFlagReportFirstExperienceCancelled then
				LoggingProtocol.default:logEventOnce("first_experience_cancelled")
			end

			game:Shutdown()
		end
	})
end
function v60.renderServerFrame(p30, p31) -- line: 525
	-- upvalues: v49 (copy), Roact (copy), v40 (copy), CoreGui (copy)
	local serverStatusText = p30.state.serverStatusText
	local isSubjectToChinaPolicies = p30.props.isSubjectToChinaPolicies
	local v192 = not v49 and 12 or 16
	local v193 = not v49 and 12 or 16

	return Roact.createElement("Frame", {
		Name = "ServerFrame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.new(1, -48, 0.2, 0)
	}, {
		PolicyLabel = isSubjectToChinaPolicies and Roact.createElement("TextLabel", {
			Name = "PolicyLabel",
			BackgroundTransparency = 1,
			TextWrapped = true,
			TextScaled = false,
			TextStrokeTransparency = 1,
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, 2 * v193),
			Position = UDim2.new(0, 0, 1, -4 * v192 - 2 * v193),
			Font = p31.Font.Footer.Font,
			TextSize = v193,
			TextColor3 = p31.Theme.TextDefault.Color,
			Text = v40:Format("Authentication.Login.WeChat.AntiAddictionText"),
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		JoinServerLabel = Roact.createElement("TextLabel", {
			Name = "JoinText",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 4 * v192),
			Position = UDim2.new(0, 0, 1, -2 * v192),
			Font = p31.Font.Footer.Font,
			TextSize = v192,
			TextWrapped = true,
			TextScaled = false,
			TextColor3 = p31.Theme.TextDefault.Color,
			TextStrokeTransparency = 1,
			Text = serverStatusText,
			TextXAlignment = Enum.TextXAlignment.Center,
			TextYAlignment = Enum.TextYAlignment.Center,
			ZIndex = 2,
			RootLocalizationTable = CoreGui.CoreScriptLocalization,
			[Roact.Event.InputBegan] = not p30.props.isSubjectToChinaPolicies and p30.showConnnectionHealthDebugMenu or nil
		})
	})
end
function v60.renderGamepadCancelBtn(p32, p33) -- line: 578
	-- upvalues: Responsive (copy), Roact (copy), v40 (copy)
	return p32.props.preferredInputRef.current == Responsive.Input.Directional and (not p32.state.gamepadCancelPressed and Roact.createElement("Frame", {
		Name = "GamepadCancelFrame",
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.fromOffset(150, 48)
	}, {
		CancelIcon = Roact.createElement("ImageLabel", {
			Name = "GamepadCancel",
			Image = "rbxasset://textures/ui/Controls/DesignSystem/ButtonB@2x.png",
			BackgroundTransparency = 1,
			Active = false,
			ZIndex = 10,
			LayoutOrder = 0,
			Size = UDim2.fromOffset(24, 24)
		}),
		CancelLabel = Roact.createElement("TextLabel", {
			Name = "CancelText",
			BackgroundTransparency = 1,
			TextSize = 24,
			TextWrapped = true,
			TextStrokeTransparency = 1,
			ZIndex = 2,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 1),
			Font = p33.Font.SubHeader1.Font,
			TextColor3 = p33.Theme.TextEmphasis.Color,
			Text = v40:Format("CoreScripts.TopBar.Back"),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, 5)
		})
	}))
end
function v60.init(p34) -- line: 624
	-- upvalues: vector2 (copy), v49 (copy), QueueExperimentation (copy), ContextActionService (copy), t9 (copy), Roact (copy), FFlagAddAutoTranslateToLoadingScreen (copy), t2 (copy), v51 (copy), GuiService (copy)
	p34.thumbnailMoveSpd = 0.05
	p34.fadeinComplete = false
	p34.isPortrait = false
	p34.startTime = tick()
	p34.numberOfTaps = 0
	p34.lastTapTime = 1e999
	p34:setState({
		visible = true,
		thumbnailPositionX = 0.5,
		shimPos = 0,
		serverStatusText = "",
		showCloseBtn = false,
		gamepadCancelPressed = false,
		absoluteSize = Vector2.new(0, 0),
		thumbnailScaledWidth = vector2.x,
		thumbnailScaledHeight = vector2.y,
		showTenFootCancelBtn = v49
	})
	p34.isQueueTreatmentEnabled = (QueueExperimentation.getIsJoinNewServerButtonEnabled() or QueueExperimentation.getIsAutoJoinNewServerEnabled()) and p34.props.placeId > 0

	function p34.onAbsoluteSizeChange(p35) -- line: 653
		-- upvalues: p34 (copy)
		p34:setState({
			absoluteSize = p35.AbsoluteSize
		})
		p34.isPortrait = p35.AbsoluteSize.X < p35.AbsoluteSize.Y
		p34.updateBindings.iconSize(1)
	end

	game.Loaded:Connect(function() -- line: 662
		-- upvalues: v49 (copy), ContextActionService (copy), p34 (copy), t9 (copy)
		if v49 then
			ContextActionService:UnbindCoreAction("CancelGameLoad")
		end

		while not p34.fadeinComplete do
			wait()
		end

		p34:stopAnimation()
		p34:playAnimation(t9.FadeOut, {}, function() -- line: 670
			-- upvalues: p34 (copy)
			p34:setState({
				visible = false
			})
		end)
	end)

	local v197, v198 = Roact.createBinding(1)
	local v199, v200 = Roact.createBinding(1)
	local v201, v202 = Roact.createBinding(0)
	local v203, v204 = Roact.createBinding(1)
	local v205, v206 = Roact.createBinding(0)
	local v207, v208 = Roact.createBinding(1)
	local v209, v210 = Roact.createBinding(0)
	local v211, v212 = Roact.createBinding(1)
	local v213 = nil
	local v214 = nil

	if FFlagAddAutoTranslateToLoadingScreen then
		v213, v214 = Roact.createBinding(Vector2.new(0, 0))
	end

	p34.bindings = {
		thumbnailTransparency = v197,
		iconTransparency = v199,
		iconSize = v201:map(function(p36) -- line: 694
			-- upvalues: p34 (copy), t2 (copy)
			local v235 = math.clamp(math.max(p34.state.absoluteSize.X, p34.state.absoluteSize.Y) / 1024 * t2[1], t2[1], t2[2])

			return UDim2.fromOffset(v235 * p36, v235 * p36)
		end),
		placeTextTransparency = v203,
		placeTextSize = v205:map(function(p37) -- line: 700
			-- upvalues: v51 (copy)
			return (not v51 and 36 or 20) * p37
		end),
		creatorTextTransparency = v207,
		creatorTextSize = v209:map(function(p38) -- line: 704
			return 20 * p38
		end),
		infoFrameTransparency = v211,
		infoFrameAbsoluteSize = if not FFlagAddAutoTranslateToLoadingScreen then nil else v213
	}
	p34.updateBindings = {
		thumbnailTransparency = v198,
		iconTransparency = v200,
		iconSize = v202,
		placeTextTransparency = v204,
		placeTextSize = v206,
		creatorTextTransparency = v208,
		creatorTextSize = v210,
		infoFrameTransparency = v212,
		updateInfoFrameAbsoluteSize = if not FFlagAddAutoTranslateToLoadingScreen then nil else v214
	}

	function p34.renderBackgroundSteppedCallback(p39) -- line: 724
		-- upvalues: p34 (copy), vector2 (copy)
		local absoluteSize = p34.state.absoluteSize
		local v240 = absoluteSize.x * 1.5
		local v241 = v240 / vector2.x * vector2.y

		if v241 < absoluteSize.y then
			v240 = absoluteSize.y / vector2.y * vector2.x
			v241 = absoluteSize.y
		end

		local v242 = v240 / absoluteSize.x / 2
		local v243 = math.max(v242, 1 - v242)
		local v244 = math.min(v242, 1 - v242)
		local v245 = p34.state.thumbnailPositionX + p34.thumbnailMoveSpd * p39

		if v243 <= v245 or v245 <= v244 then
			p34.thumbnailMoveSpd = -p34.thumbnailMoveSpd
			v245 = math.clamp(v245, v244, v243)
		end

		p34:setState({
			thumbnailPositionX = v245,
			thumbnailScaledHeight = v241,
			thumbnailScaledWidth = v240
		})
	end
	function p34.renderShimmerCallback(p40) -- line: 751
		-- upvalues: p34 (copy)
		local v247 = p34.state.shimPos + p40 * 1

		if v247 > 1 then
			v247 = -1
		end

		p34:setState({
			shimPos = v247
		})
	end

	if GuiService:GetUiMessage() ~= "" then
		p34:setState({
			serverStatusText = GuiService:GetUiMessage()
		})
	end

	GuiService.UiMessageChanged:Connect(function(p41, p42) -- line: 768
		-- upvalues: p34 (copy)
		if p41 == Enum.UiMessageType.UiMessageInfo then
			p34:setState({
				serverStatusText = p42
			})
		end
	end)

	local u215 = false

	ContextActionService:BindCoreAction("CancelGameLoad", function(_, p44, _) -- line: 776
		-- upvalues: u215 (ref), p34 (copy), ContextActionService (copy)
		if p44 == Enum.UserInputState.Begin then
			u215 = true

			return
		end

		if p44 == Enum.UserInputState.End and u215 then
			p34:setState({
				showTenFootCancelBtn = false
			})
			p34:setState({
				gamepadCancelPressed = true
			})
			ContextActionService:UnbindCoreAction("CancelGameLoad")

			if not game:IsLoaded() then
				game:Shutdown()
			end
		end
	end, false, Enum.KeyCode.ButtonB)
end
function v60.renderAutoTranslate(p46) -- line: 796
	-- upvalues: FFlagAutoTranslateSkipZeroUniverseId (copy), LoadingScreenTelemetry (copy), Roact (copy), AutoTranslateBadge (copy)
	if FFlagAutoTranslateSkipZeroUniverseId and p46.props.universeId <= 0 then
		LoadingScreenTelemetry.countAutoTranslateZeroUniverseId()

		return nil
	end

	return Roact.createElement(AutoTranslateBadge, {
		universeId = p46.props.universeId,
		positionBinding = p46.bindings.infoFrameAbsoluteSize,
		transparencyBinding = p46.bindings.infoFrameTransparency
	})
end
function v60.renderPolicyContainer(p47) -- line: 808
	-- upvalues: React (copy), PolicyContainer (copy)
	if not p47.props.isSubjectToChinaPolicies then
		return nil
	end

	return React.createElement(PolicyContainer, {
		position = UDim2.new(0, 0, 0, 32)
	})
end
function v60.renderServerStatus(p48) -- line: 817
	-- upvalues: QueueExperimentation (copy), Roact (copy), ServerStatusWithCountdown (copy), ServerStatus (copy)
	if QueueExperimentation.getIsAutoJoinNewServerEnabled() then
		return Roact.createElement(ServerStatusWithCountdown, {
			anchorPoint = Vector2.new(0.5, 1),
			isSubjectToChinaPolicies = p48.props.isSubjectToChinaPolicies,
			placeId = p48.props.placeId,
			position = UDim2.fromScale(0.5, 1),
			size = UDim2.fromScale(1, 0.2),
			universeId = p48.props.universeId
		})
	end

	if QueueExperimentation.getIsJoinNewServerButtonEnabled() then
		return Roact.createElement(ServerStatus, {
			anchorPoint = Vector2.new(0.5, 1),
			isSubjectToChinaPolicies = p48.props.isSubjectToChinaPolicies,
			placeId = p48.props.placeId,
			position = UDim2.fromScale(0.5, 1),
			size = UDim2.fromScale(1, 0.2),
			universeId = p48.props.universeId
		})
	end

	return nil
end
function v60.renderMainWithProviders(p49, p50) -- line: 841
	-- upvalues: Roact (copy), FoundationProvider (copy), Foundation (copy), LocalizationProvider (copy), v40 (copy)
	return Roact.createElement(FoundationProvider, {
		theme = Foundation.Enums.Theme.Dark
	}, { Roact.createElement(LocalizationProvider, {
		localization = v40
	}, p49:renderMain(p50)) })
end
function v60.render(p51) -- line: 851
	-- upvalues: withStyle (copy), Roact (copy), FFlagAddAutoTranslateToLoadingScreen (copy)
	return withStyle(function(p52) -- line: 854
		-- upvalues: p51 (copy), Roact (copy), FFlagAddAutoTranslateToLoadingScreen (copy)
		return p51.state.visible and Roact.createElement("Folder", {}, {
			BackgroundScreen = p51:renderBackground(p52),
			MainScreen = if not FFlagAddAutoTranslateToLoadingScreen then p51:renderMain(p52) else p51:renderMainWithProviders(p52)
		})
	end)
end
function v60.willUpdate(_, _, _) -- line: 865
end
function v60.didMount(p56) -- line: 867
	-- upvalues: RunService (copy), t9 (copy), QueueExperimentation (copy), ExperienceService (copy), PlaceLauncherState (copy)
	RunService:SetRobloxGuiFocused(true)
	p56.props.fetchUniverseId(p56.props.placeId)
	p56.props.fetchGameProductInfo(p56.props.placeId)
	p56.props.fetchSubjectToChinaPolicies()
	p56:playAnimation(t9.FadeIn, {}, function() -- line: 876
		-- upvalues: p56 (copy)
		p56.fadeinComplete = true
	end)

	if QueueExperimentation.isInExperiment() and (ExperienceService:GetFollowUserId() > 0 and p56.props.placeId > 0) then
		if ExperienceService:GetPlaceJoinState() == PlaceLauncherState.Queued then
			QueueExperimentation.logExposure()

			return
		end

		p56.placeJoinStateConnection = ExperienceService.PlaceJoinStateChanged:Connect(function(p57) -- line: 884
			-- upvalues: PlaceLauncherState (copy), QueueExperimentation (copy)
			if p57 == PlaceLauncherState.Queued then
				QueueExperimentation.logExposure()
			end
		end)
	end
end
function v60.willUnmount(p58) -- line: 893
	-- upvalues: ContextActionService (copy), RunService (copy), u53 (ref), UserInputService (copy), GuiService (copy), QueueExperimentation (copy)
	ContextActionService:UnbindCoreAction("CancelGameLoad")
	RunService:SetRobloxGuiFocused(false)

	if not u53 then
		u53 = UserInputService.InputBegan:Connect(function() -- line: 897
			-- upvalues: u53 (ref), GuiService (copy)
			if u53 then
				u53:disconnect()
				u53 = nil
				GuiService:CloseStatsBasedOnInputString("ConnectionHealth")
			end
		end)
	end

	if QueueExperimentation.isInExperiment() and p58.placeJoinStateConnection then
		p58.placeJoinStateConnection:Disconnect()
		p58.placeJoinStateConnection = nil
	end
end

local u61 = RoactRodux.connect(function(p59, p60) -- line: 908
	return {
		productInfo = p59.productInfo,
		isSubjectToChinaPolicies = p59.isSubjectToChinaPolicies,
		placeId = p59.gameIds and p59.gameIds.placeId or p60.placeId,
		universeId = p59.gameIds and p59.gameIds.universeId or 0,
		settings = p59.settings
	}
end, function(p61) -- line: 916
	-- upvalues: GetGameProductInfo (copy), GetIsSubjectToChinaPolicies (copy), GetUniverseId (copy), v44 (copy)
	return {
		fetchGameProductInfo = function(p62) -- line: 918
			-- upvalues: p61 (copy), GetGameProductInfo (copy)
			p61(GetGameProductInfo(p62))
		end,
		fetchSubjectToChinaPolicies = function() -- line: 921
			-- upvalues: p61 (copy), GetIsSubjectToChinaPolicies (copy)
			p61(GetIsSubjectToChinaPolicies())
		end,
		fetchUniverseId = function(p63) -- line: 924
			-- upvalues: p61 (copy), GetUniverseId (copy), v44 (copy)
			p61(GetUniverseId(v44, p63))
		end
	}
end)(v60)

return function(p64) -- line: 929
	-- upvalues: React (copy), Responsive (copy), u61 (ref), Cryo (copy)
	local v231 = React.useRef(nil)

	v231.current = Responsive.usePreferredInput()

	return React.createElement(u61, Cryo.Dictionary.join(p64, {
		preferredInputRef = v231
	}))
end
