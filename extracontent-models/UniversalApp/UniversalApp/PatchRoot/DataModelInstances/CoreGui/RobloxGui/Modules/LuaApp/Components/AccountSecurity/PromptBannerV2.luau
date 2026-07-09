local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local DisplayType = require(Modules.LuaApp.Enum.AccountSecurity.DisplayType)
local GetFFlagDebugShowAccountSecurityPromptBanner = require(Modules.LuaApp.Flags.GetFFlagDebugShowAccountSecurityPromptBanner)
local GetFFlagLuaAppAccountSecurityPromptEnabled = require(Modules.LuaApp.Flags.GetFFlagLuaAppAccountSecurityPromptEnabled)
local GetFFlagLuaAppAccountSecurityPromptRollout = require(Modules.LuaApp.Flags.GetFFlagLuaAppAccountSecurityPromptRollout)
local GetFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled = require(CorePackages.Workspace.Packages.PromptAssignments).Flags.GetFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled
local GetFFlagLuaAppAuthenticatorUpsellPopUpEnabled = require(CorePackages.Workspace.Packages.PromptAssignments).Flags.GetFFlagLuaAppAuthenticatorUpsellPopUpEnabled
local GetFFlagLuaAppEmail2SVUpsellPopUpEnabled = require(Modules.LuaApp.Flags.GetFFlagLuaAppEmail2SVUpsellPopUpEnabled)
local GetFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled = require(CorePackages.Workspace.Packages.PromptAssignments).Flags.GetFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled
local GetFIntLuaAppAccountSecurityPromptForcePopUpRenderAfterSeconds = require(Modules.LuaApp.Flags.GetFIntLuaAppAccountSecurityPromptForcePopUpRenderAfterSeconds)
local GetFIntLuaAppAccountSecurityPromptPollingIntervalSeconds = require(Modules.LuaApp.Flags.GetFIntLuaAppAccountSecurityPromptPollingIntervalSeconds)
local GetFIntLuaAppAccountSecurityPromptPollingIntervalSecondsVisible = require(Modules.LuaApp.Flags.GetFIntLuaAppAccountSecurityPromptPollingIntervalSecondsVisible)
local GetFIntLuaAppAccountSecurityPromptPopUpSpawnDelay = require(Modules.LuaApp.Flags.GetFIntLuaAppAccountSecurityPromptPopUpSpawnDelay)
local GetDaysRemainingToForceResetString = require(Modules.LuaApp.Components.AccountSecurity.Helpers.GetDaysRemainingToForceResetString)
local v22 = game:DefineFastFlag("PromptBannerWaitInSmallIntervals", false)
local FFlagPasskeyUpsellFilteringEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPasskeyUpsellFilteringEnabled
local FilterOutPasskeyUpsell = require(Modules.LuaApp.Components.AccountSecurity.Helpers.FilterOutPasskeyUpsell)
local CurrentTabContext = require(Modules.LuaApp.Navigation.CurrentTabContext)
local GetPromptAssignments = require(Modules.LuaApp.Thunks.AccountSecurity.GetPromptAssignments)
local ModalState = require(Modules.LuaApp.Enum.AccountSecurity.ModalState)
local NavigateDownToSecuritySettings = require(Modules.LuaApp.Thunks.NavigateDownToSecuritySettings)
local OpenWebview = require(Modules.LuaApp.Thunks.OpenWebview)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local PromptAssignmentAction = require(Modules.LuaApp.Enum.AccountSecurity.PromptAssignmentAction)
local PromptConstants = require(Modules.LuaApp.Components.AccountSecurity.Common.PromptConstants)
local PromptType = require(Modules.LuaApp.Enum.AccountSecurity.PromptType)
local Roact = require(Modules.Common.Roact)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactRodux = require(Modules.Common.RoactRodux)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local SetCentralOverlay = require(Modules.LuaApp.Actions.SetCentralOverlay)
local TouchFriendlyIconButton = require(Modules.LuaApp.Components.Generic.TouchFriendlyIconButton)
local UpdatePromptAssignment = require(Modules.LuaApp.Thunks.AccountSecurity.UpdatePromptAssignment)
local UpdatePromptTypeWithEvent = require(Modules.LuaApp.Thunks.AccountSecurity.UpdatePromptTypeWithEvent)
local withLocalization = require(Modules.LuaApp.withLocalization)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local withStyle = UIBlox.Style.withStyle
local u51 = nil
local v52 = Images["icons/status/alert"]
local v53 = Images["icons/navigation/close"]
local Red = UIBlox.App.Style.Colors.Red
local t1 = {
	[PromptType.ChangePasswordSuspectedCompromise] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.UnusualActivityDetected",
		descriptionEnd = "Feature.AccountSecurityPrompt.Description.ChangeYourPasswordClickHereStyled",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.UnusualActivity"
	},
	[PromptType.ChangePasswordBreachedCredential] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.YourPasswordMightBeStolen",
		descriptionEnd = "Feature.AccountSecurityPrompt.Description.NoChangeForceReset",
		descriptionEndSingular = "Feature.AccountSecurityPrompt.Description.NoChangeForceResetSingular",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.ChangeYourPasswordClickHereStyled"
	},
	[PromptType.AccountRestoresPolicyUpdate] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.AccountRestoresPolicyUpdate",
		descriptionEnd = "Feature.AccountSecurityPrompt.Description.AuthenticatorSetupPromptClickHere",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.AccountRestoresPolicyWithDate",
		settingsTitle = "CommonUI.Features.Label.Settings"
	},
	[PromptType.AccountRestoresPolicyUpdateV2] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.KeepYourAccountSafeShort",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.AuthenticatorSetupPromptNewShort",
		settingsTitle = "CommonUI.Features.Label.Help"
	},
	[PromptType.AccountRestoresPolicyUpdateV3] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.AccountRestoresPolicyUpdateV3",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.AccountRestoresPolicyUpdateV3Short",
		settingsTitle = "CommonUI.Features.Label.Settings"
	},
	[PromptType.Email2SVUpsell] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.Email2SVUpsell",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.Email2SVUpsellMessageBody",
		settingsTitle = "CommonUI.Features.Label.Settings"
	}
}
local v56 = Roact.PureComponent:extend(script.Name)

v56.defaultProps = {
	isInteractive = true
}

function v56.init(p1) -- line: 132
	-- upvalues: FFlagPasskeyUpsellFilteringEnabled (copy), FilterOutPasskeyUpsell (copy), PromptType (copy), DisplayType (copy), u51 (ref), GetFIntLuaAppAccountSecurityPromptForcePopUpRenderAfterSeconds (copy), PromptAssignmentAction (copy), PromptConstants (copy), ModalState (copy)
	p1:setState({
		requestInFlightForDismissButton = false,
		forceRenderValue = 0
	})

	function p1.refreshPromptState() -- line: 139
		-- upvalues: p1 (copy), FFlagPasskeyUpsellFilteringEnabled (copy), FilterOutPasskeyUpsell (copy), PromptType (copy), DisplayType (copy), u51 (ref), GetFIntLuaAppAccountSecurityPromptForcePopUpRenderAfterSeconds (copy)
		p1.props.getPromptAssignments(p1.props.networking):andThen(function(p2) -- line: 142
			-- upvalues: FFlagPasskeyUpsellFilteringEnabled (copy), FilterOutPasskeyUpsell (copy), PromptType (copy), DisplayType (copy), p1 (copy), u51 (ref), GetFIntLuaAppAccountSecurityPromptForcePopUpRenderAfterSeconds (copy)
			local isGeneric = nil
			local v117 = nil
			local metadata = nil

			if FFlagPasskeyUpsellFilteringEnabled then
				p2 = FilterOutPasskeyUpsell(p2)
			end

			if #p2 > 0 then
				isGeneric = p2[1].isGeneric
				v117 = PromptType.fromRawValue(p2[1].promptType)

				if v117 ~= nil then
					metadata = p2[1].metadata
				elseif v117 == nil and typeof(p2[1].metadata) == "table" and DisplayType.fromRawValue(p2[1].metadata.displayType) ~= nil then
					v117 = p2[1].promptType
					metadata = p2[1].metadata
				else
					isGeneric = nil
				end
			end

			if v117 ~= p1.props.promptType then
				u51 = nil
			end

			local v119 = GetFIntLuaAppAccountSecurityPromptForcePopUpRenderAfterSeconds()

			if v119 >= 0 and u51 ~= nil and v119 <= DateTime.now().UnixTimestamp - u51.UnixTimestamp then
				u51 = nil

				if p1.isMounted then
					p1:setState({
						forceRenderValue = p1.state.forceRenderValue + 1
					})
				end
			end

			p1.props.updatePromptType(p1.props.analytics, isGeneric, v117, metadata)
		end):catch(function(_) -- line: 204
		end):await()
	end
	function p1.disablePromptAssignment(p4) -- line: 210
		-- upvalues: p1 (copy), PromptAssignmentAction (copy)
		p1:setState({
			requestInFlightForDismissButton = true
		})
		p1.props.updatePromptAssignment(p1.props.networking, p1.props.promptType, p4 and PromptAssignmentAction.DismissPrompt or PromptAssignmentAction.DisablePrompt):andThen(function() -- line: 222
			-- upvalues: p1 (copy)
			p1.props.updatePromptType(p1.props.analytics, nil, nil, nil)
			p1.refreshPromptState()
			spawn(function() -- line: 232
				-- upvalues: p1 (copy)
				if not p1.isMounted then
					return
				end

				p1:setState({
					requestInFlightForDismissButton = false
				})
			end)
		end):catch(function(_) -- line: 242
			-- upvalues: p1 (copy)
			if not p1.isMounted then
				return
			end

			p1:setState({
				requestInFlightForDismissButton = false
			})
		end)
	end
	function p1.handlePrimary(p6) -- line: 254
		-- upvalues: p1 (copy), PromptType (copy), PromptConstants (copy), ModalState (copy)
		return function() -- line: 255
			-- upvalues: p1 (copy), PromptType (copy), PromptConstants (copy), p6 (copy), ModalState (copy)
			if p1.props.promptType == PromptType.AccountRestoresPolicyUpdate then
				task.spawn(p1.disablePromptAssignment)
				p1.props.openWebView(PromptConstants.getWebViewUrlAccountSettings(), p6)

				return
			end

			if p1.props.promptType == PromptType.AccountRestoresPolicyUpdateV2 then
				task.spawn(p1.disablePromptAssignment)
				p1.props.openWebView(PromptConstants.getWebViewUrlHelpPage(), p6)

				return
			end

			if p1.props.promptType == PromptType.AccountRestoresPolicyUpdateV3 then
				p1.props.navigateToSecuritySettings()

				return
			end

			if p1.props.promptType == PromptType.Email2SVUpsell then
				p1.props.openWebView(PromptConstants.getWebViewUrlEmailHighlight(), p6)

				return
			end

			if p1.props.isGeneric then
				return
			end

			p1.props.openOverlayWithModalState(ModalState.ChangePasswordIntro)
		end
	end
	function p1.handleDismissOrDisable() -- line: 276
		-- upvalues: p1 (copy), PromptType (copy), ModalState (copy)
		if p1.props.promptType == PromptType.AccountRestoresPolicyUpdate or (p1.props.promptType == PromptType.AccountRestoresPolicyUpdateV2 or p1.props.promptType == PromptType.AccountRestoresPolicyUpdateV3 or p1.props.isGeneric) then
			p1.disablePromptAssignment()

			return
		end

		if p1.props.promptType == PromptType.Email2SVUpsell then
			p1.disablePromptAssignment(true)

			return
		end

		p1.props.openOverlayWithModalState(ModalState.ChangePasswordDismissConfirmation)
	end
end
function v56.didMount(p7) -- line: 292
	-- upvalues: GetFFlagLuaAppAccountSecurityPromptEnabled (copy), GetFFlagLuaAppAccountSecurityPromptRollout (copy), GetFIntLuaAppAccountSecurityPromptPollingIntervalSeconds (copy), GetFIntLuaAppAccountSecurityPromptPollingIntervalSecondsVisible (copy), v22 (copy)
	p7.isMounted = true
	spawn(function() -- line: 296
		-- upvalues: p7 (copy), GetFFlagLuaAppAccountSecurityPromptEnabled (copy), GetFFlagLuaAppAccountSecurityPromptRollout (copy), GetFIntLuaAppAccountSecurityPromptPollingIntervalSeconds (copy), GetFIntLuaAppAccountSecurityPromptPollingIntervalSecondsVisible (copy), v22 (copy)
		while p7.isMounted and GetFFlagLuaAppAccountSecurityPromptEnabled() and GetFFlagLuaAppAccountSecurityPromptRollout(p7.props.userId) do
			local lastUpdatedPromptTypeAt = p7.props.lastUpdatedPromptTypeAt
			local UnixTimestampMillis = DateTime.now().UnixTimestampMillis
			local v98 = if p7.props.promptType ~= nil then GetFIntLuaAppAccountSecurityPromptPollingIntervalSecondsVisible() else GetFIntLuaAppAccountSecurityPromptPollingIntervalSeconds()

			if lastUpdatedPromptTypeAt == nil or UnixTimestampMillis - lastUpdatedPromptTypeAt.UnixTimestampMillis > v98 * 1000 then
				p7.refreshPromptState()
			end

			if v22 then
				local v99 = os.clock() + v98

				while v99 > os.clock() and p7.isMounted do
					wait(1)
				end
			else
				wait(v98)
			end
		end

		if p7.isMounted then
			p7.props.updatePromptType(p7.props.analytics, nil, nil, nil)
		end
	end)
end
function v56.willUnmount(p8) -- line: 348
	p8.isMounted = false
end
function v56.wrapInFrame(p9, p10) -- line: 352
	-- upvalues: Roact (copy)
	local propsPosition = p9.props.Position
	local propsSize = p9.props.Size
	local v66 = p9.props[Roact.Change.AbsoluteSize]

	return Roact.createElement("Frame", {
		[Roact.Change.AbsoluteSize] = v66,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = propsPosition,
		Size = propsSize or UDim2.fromScale(1, 0)
	}, p10)
end
function v56.renderInternal(p11) -- line: 367
	-- upvalues: GetFFlagDebugShowAccountSecurityPromptBanner (copy), PromptType (copy), t1 (copy), GetFFlagLuaAppAuthenticatorUpsellPopUpEnabled (copy), GetFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled (copy), GetFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled (copy), GetFFlagLuaAppEmail2SVUpsellPopUpEnabled (copy), Roact (copy), CurrentTabContext (copy), ModalState (copy), u51 (ref), GetFIntLuaAppAccountSecurityPromptPopUpSpawnDelay (copy), withStyle (copy), withLocalization (copy), GetDaysRemainingToForceResetString (copy), LocalizationService (copy), Red (copy), ImageSetLabel (copy), v52 (copy), StyledTextLabel (copy), Loading (copy), IconSize (copy), TouchFriendlyIconButton (copy), v53 (copy)
	local isGeneric = p11.props.isGeneric
	local promptType = p11.props.promptType
	local metadata = p11.props.metadata
	local v71 = metadata ~= nil and (metadata.showBanner == nil or metadata.showBanner == false)
	local isInteractive = p11.props.isInteractive
	local designTokens = p11.props.designTokens
	local v74 = if not designTokens then nil else designTokens.strokeColor
	local v75 = if not designTokens then nil else designTokens.cornerRadius
	local requestInFlightForDismissButton = p11.state.requestInFlightForDismissButton

	if GetFFlagDebugShowAccountSecurityPromptBanner() and not promptType then
		promptType = PromptType.ChangePasswordSuspectedCompromise
	end

	local u77 = t1[promptType]
	local v78 = GetFFlagLuaAppAuthenticatorUpsellPopUpEnabled() and promptType == PromptType.AuthenticatorUpsell
	local v79 = GetFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled() and promptType == PromptType.BroaderAuthenticatorUpsell
	local v80 = GetFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled() and promptType == PromptType.AccountRestoresPolicyUpsell
	local v81 = GetFFlagLuaAppEmail2SVUpsellPopUpEnabled() and promptType == PromptType.Email2SVUpsell

	if isGeneric then
		u77 = if metadata == nil or (metadata.bodyResource == nil or metadata.headerResource == nil) then {} else {
			descriptionStart = "Feature.AccountSecurityPrompt." .. metadata.bodyResource,
			bannerHeader = "Feature.AccountSecurityPrompt." .. metadata.headerResource
		}
	elseif u77 == nil and not v78 and not v79 and not v80 and (not v81 or v71) then
		return nil
	end

	local u82 = true

	if isGeneric then
		u82 = false
	end

	local u83 = promptType ~= PromptType.ChangePasswordBreachedCredential

	if isGeneric and typeof(metadata) == "table" and metadata.showXButtonForDisable == false then
		u83 = false
	end

	if not isInteractive then
		u83 = false
	end

	local uDim2 = UDim2.new(0, 65, 0, 0)
	local uDim2_2 = UDim2.new(1, -65, 0, 0)
	local u86 = promptType ~= PromptType.AccountRestoresPolicyUpdateV3

	if isGeneric and typeof(metadata) == "table" and metadata.showAlertIcon == false then
		u86 = false
	end

	if not u86 then
		uDim2 = UDim2.new(0, 0, 0, 0)
		uDim2_2 = UDim2.new(1, not u83 and 0 or -15, 0, 0)
	end

	return Roact.createElement(CurrentTabContext.Consumer, {
		render = function(p12) -- line: 462
			-- upvalues: metadata (copy), v78 (copy), v79 (copy), ModalState (copy), v80 (copy), v81 (copy), v71 (copy), u51 (ref), GetFIntLuaAppAccountSecurityPromptPopUpSpawnDelay (copy), p11 (copy), withStyle (copy), withLocalization (copy), u77 (ref), promptType (ref), PromptType (copy), GetDaysRemainingToForceResetString (copy), LocalizationService (copy), Roact (copy), u82 (ref), isInteractive (copy), u83 (ref), u86 (ref), Red (copy), ImageSetLabel (copy), v52 (copy), uDim2 (ref), uDim2_2 (ref), StyledTextLabel (copy), requestInFlightForDismissButton (copy), Loading (copy), IconSize (copy), TouchFriendlyIconButton (copy), v53 (copy), v74 (copy), v75 (copy)
			local v101 = p12 == "Home"

			if metadata ~= nil and (metadata.pageRestriction == "PAGE_RESTRICTION_HOME_PAGE" and v101 ~= true) then
				return nil
			end

			local AuthenticatorUpsellIntro = nil

			if v78 or v79 then
				AuthenticatorUpsellIntro = ModalState.AuthenticatorUpsellIntro
			elseif v80 then
				AuthenticatorUpsellIntro = ModalState.AccountRestoresPolicyUpsell
			elseif v81 and v71 then
				AuthenticatorUpsellIntro = ModalState.Email2SVUpsell
			end

			if AuthenticatorUpsellIntro ~= nil then
				if u51 == nil then
					local v103 = GetFIntLuaAppAccountSecurityPromptPopUpSpawnDelay()

					if v103 >= 0 then
						task.delay(v103, function() -- line: 496
							-- upvalues: p11 (copy), AuthenticatorUpsellIntro (ref)
							p11.props.openOverlayWithModalState(AuthenticatorUpsellIntro)
						end)
					else
						p11.props.openOverlayWithModalState(AuthenticatorUpsellIntro)
					end

					u51 = DateTime.now()
				end

				return nil
			end

			return withStyle(function(p13) -- line: 509
				-- upvalues: withLocalization (copy), u77 (ref), promptType (ref), PromptType (copy), GetDaysRemainingToForceResetString (copy), metadata (copy), LocalizationService (copy), Roact (copy), u82 (ref), p11 (copy), isInteractive (copy), u83 (ref), u86 (ref), Red (copy), ImageSetLabel (copy), v52 (copy), uDim2 (ref), uDim2_2 (ref), StyledTextLabel (copy), requestInFlightForDismissButton (copy), Loading (copy), IconSize (copy), TouchFriendlyIconButton (copy), v53 (copy), v74 (copy), v75 (copy)
				local TextLinkColor = p13.Theme.TextLink.Color
				local v124 = string.format("rgb(%d, %d, %d)", math.round(TextLinkColor.R * 255), math.round(TextLinkColor.G * 255), (math.round(TextLinkColor.B * 255)))

				return withLocalization(u77)(function(p14) -- line: 518
					-- upvalues: v124 (copy), promptType (ref), PromptType (copy), GetDaysRemainingToForceResetString (copy), metadata (copy), LocalizationService (copy), Roact (copy), u82 (ref), p11 (copy), isInteractive (copy), p13 (copy), u83 (ref), u86 (ref), Red (copy), ImageSetLabel (copy), v52 (copy), uDim2 (ref), uDim2_2 (ref), StyledTextLabel (copy), requestInFlightForDismissButton (copy), Loading (copy), IconSize (copy), TouchFriendlyIconButton (copy), v53 (copy), v74 (copy), v75 (copy)
					if p14 == nil or (p14.bannerHeader == nil or p14.bannerHeader == "" or p14.descriptionStart == nil or p14.descriptionStart == "") then
						return nil
					end

					local v126 = p14.descriptionStart:gsub("{styleTagStart}", "<font color=\"" .. v124 .. "\">"):gsub("{styleTagEnd}", "</font>"):gsub("{linkStart}", "<font color=\"" .. v124 .. "\">"):gsub("{linkEnd}", "</font>")
					local v127 = p14.descriptionEnd ~= nil and p14.descriptionEnd:gsub("{styleTagStart}", "<font color=\"" .. v124 .. "\">"):gsub("{styleTagEnd}", "</font>") or nil
					local v128 = false

					if promptType == PromptType.ChangePasswordBreachedCredential then
						v127 = GetDaysRemainingToForceResetString(p14.descriptionEndSingular, p14.descriptionEnd, metadata.forceResetTimestamp)
					elseif promptType == PromptType.AccountRestoresPolicyUpdate then
						v128 = true
						v126 = v126:gsub("{date}", DateTime.fromIsoDate(metadata.accountRestoresPolicyEffectiveTimestamp):FormatUniversalTime("D MMM YYYY", LocalizationService.RobloxLocaleId or "en-us"))
					end

					return promptType and {
						BannerFrame = Roact.createElement("TextButton", {
							[Roact.Event.Activated] = if not u82 then nil else p11.handlePrimary(p14.settingsTitle),
							AutoButtonColor = isInteractive,
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundColor3 = p13.Theme.SystemPrimaryContent.Color,
							BackgroundTransparency = p13.Theme.SystemPrimaryContent.Transparency,
							BorderSizePixel = 0,
							Size = UDim2.fromScale(1, 0),
							Text = "",
							SelectionImageObject = p11.props.selectionCursor
						}, {
							Padding = Roact.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 15),
								PaddingRight = UDim.new(0, 15),
								PaddingTop = UDim.new(0, 15),
								PaddingBottom = UDim.new(0, 15)
							}),
							BannerLeftFrame = Roact.createElement("Frame", {
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								AutomaticSize = Enum.AutomaticSize.Y,
								Size = UDim2.fromScale(not u83 and 1 or 0.9, 0)
							}, {
								IconFrame = u86 and Roact.createElement("Frame", {
									BackgroundTransparency = 0,
									BorderSizePixel = 0,
									BackgroundColor3 = Red,
									Size = UDim2.fromOffset(50, 50)
								}, {
									UICorner = Roact.createElement("UICorner", {
										CornerRadius = UDim.new(0, 10)
									}),
									Icon = Roact.createElement(ImageSetLabel, {
										BackgroundTransparency = 1,
										AnchorPoint = Vector2.new(0.5, 0.5),
										Image = v52,
										Position = UDim2.fromScale(0.5, 0.5),
										Size = UDim2.fromOffset(36, 36)
									})
								}),
								HeaderContentFrame = Roact.createElement("Frame", {
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									AutomaticSize = Enum.AutomaticSize.Y,
									Position = uDim2,
									Size = uDim2_2
								}, {
									ListLayout = Roact.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										SortOrder = Enum.SortOrder.LayoutOrder
									}),
									Header = Roact.createElement(StyledTextLabel, {
										layoutOrder = 1,
										lineHeight = 1,
										automaticSize = Enum.AutomaticSize.Y,
										colorStyle = p13.Theme.SystemPrimaryDefault,
										fontStyle = p13.Font.Header1,
										size = UDim2.new(1, 0, 0, 0),
										text = p14.bannerHeader,
										textXAlignment = Enum.TextXAlignment.Left,
										textYAlignment = Enum.TextYAlignment.Top
									}),
									Spacer = Roact.createElement("Frame", {
										LayoutOrder = 2,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.fromOffset(0, 15)
									}),
									ContentDescriptionLabel = Roact.createElement(StyledTextLabel, {
										layoutOrder = 3,
										lineHeight = 1,
										automaticSize = Enum.AutomaticSize.Y,
										colorStyle = p13.Theme.TextDefault,
										fontStyle = p13.Font.Body,
										size = UDim2.new(1, 0, 0, 0),
										text = not (not v128 and v127 ~= nil) and v126 or v126 .. " " .. v127,
										textXAlignment = Enum.TextXAlignment.Left,
										textYAlignment = Enum.TextYAlignment.Bottom
									}),
									Spacer2 = v128 and Roact.createElement("Frame", {
										LayoutOrder = 4,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.fromOffset(0, 15)
									}) or nil,
									ContentDescriptionLabel2 = v128 and Roact.createElement(StyledTextLabel, {
										layoutOrder = 5,
										lineHeight = 1,
										automaticSize = Enum.AutomaticSize.Y,
										colorStyle = p13.Theme.TextDefault,
										fontStyle = p13.Font.Body,
										size = UDim2.new(1, 0, 0, 0),
										text = v127,
										textXAlignment = Enum.TextXAlignment.Left,
										textYAlignment = Enum.TextYAlignment.Bottom
									}) or nil
								})
							}),
							DismissButton = u83 and (requestInFlightForDismissButton and Roact.createElement(Loading, {
								Position = UDim2.new(1, -15, 0, 15),
								size = IconSize.Medium,
								AnchorPoint = Vector2.new(0.5, 0.5)
							}) or Roact.createElement(TouchFriendlyIconButton, {
								iconSize = 28,
								useUIBloxImageSet = true,
								icon = v53,
								iconColor = p13.Theme.TextDefault.Color,
								iconPosition = UDim2.new(1, -15, 0, 15),
								iconTransparency = p13.Theme.TextDefault.Transparency,
								onActivated = p11.handleDismissOrDisable,
								Position = UDim2.fromScale(0.9, 0),
								Size = UDim2.new(0.1, 0, 0.5, 0)
							})) or nil,
							UIStroke = if not v74 then nil else Roact.createElement("UIStroke", {
								Thickness = 1,
								ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
								Color = v74.Color3,
								Transparency = v74.Transparency
							}),
							UICorner = if not v75 then nil else Roact.createElement("UICorner", {
								CornerRadius = v75
							})
						})
					} or nil
				end)
			end)
		end
	})
end
function v56.render(p15) -- line: 729
	return p15:wrapInFrame(p15:renderInternal())
end

local v57 = RoactRodux.connect(function(p16, _) -- line: 733
	return {
		lastUpdatedPromptTypeAt = p16.AccountSecurityPrompt.lastUpdatedPromptTypeAt,
		isGeneric = p16.AccountSecurityPrompt.isGeneric,
		promptType = p16.AccountSecurityPrompt.promptType,
		metadata = p16.AccountSecurityPrompt.metadata,
		userId = p16.LocalUserId
	}
end, function(p18) -- line: 741
	-- upvalues: GetPromptAssignments (copy), SetCentralOverlay (copy), OverlayType (copy), OpenWebview (copy), NavigateDownToSecuritySettings (copy), UpdatePromptTypeWithEvent (copy), UpdatePromptAssignment (copy)
	return {
		getPromptAssignments = function(p19) -- line: 743
			-- upvalues: p18 (copy), GetPromptAssignments (copy)
			return p18(GetPromptAssignments(p19))
		end,
		openOverlayWithModalState = function(p20) -- line: 746
			-- upvalues: p18 (copy), SetCentralOverlay (copy), OverlayType (copy)
			return p18(SetCentralOverlay(OverlayType.AccountSecurityPromptOverlay, {
				modalState = p20
			}))
		end,
		openWebView = function(p21, p22) -- line: 749
			-- upvalues: p18 (copy), OpenWebview (copy)
			return p18(OpenWebview(p21, p22))
		end,
		navigateToSecuritySettings = function() -- line: 752
			-- upvalues: p18 (copy), NavigateDownToSecuritySettings (copy)
			p18(NavigateDownToSecuritySettings())
		end,
		updatePromptType = function(p23, p24, p25, p26) -- line: 755
			-- upvalues: p18 (copy), UpdatePromptTypeWithEvent (copy)
			return p18(UpdatePromptTypeWithEvent(p23, p24, p25, p26))
		end,
		updatePromptAssignment = function(p27, p28, p29) -- line: 758
			-- upvalues: p18 (copy), UpdatePromptAssignment (copy)
			return p18(UpdatePromptAssignment(p27, p28, p29))
		end
	}
end)(v56)
local u58 = RoactServices.connect({
	analytics = RoactAnalytics,
	networking = RoactNetworking
})(v57)

return function(p30) -- line: 769
	-- upvalues: useSelectionCursor (copy), CursorKind (copy), useDesignTokens (copy), Roact (copy), u58 (ref), Cryo (copy)
	local v92 = useSelectionCursor(CursorKind.RoundedRect)
	local v93 = useDesignTokens()

	return Roact.createElement(u58, Cryo.Dictionary.join(p30, {
		designTokens = v93.LuaApps.Banner.securityBanner,
		selectionCursor = v92
	}))
end
