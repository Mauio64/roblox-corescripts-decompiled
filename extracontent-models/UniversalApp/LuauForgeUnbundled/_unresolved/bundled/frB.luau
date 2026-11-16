local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")

local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local iconSize = Foundation.Enums.IconSize
local loading = Foundation.Loading

local module = require("@luauforge/bundled/frC")

local module2 = require("@luauforge/bundled/fsb")

local module3 = require("@luauforge/bundled/fsc")

local module4 = require("@luauforge/bundled/fsd")

local getFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled = require("@luauforge/bundled/frE").Flags.GetFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled

local getFFlagLuaAppAuthenticatorUpsellPopUpEnabled = require("@luauforge/bundled/frE").Flags.GetFFlagLuaAppAuthenticatorUpsellPopUpEnabled
local module5 = require("@luauforge/bundled/fse")

local getFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled = require("@luauforge/bundled/frE").Flags.GetFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled

local module6 = require("@luauforge/bundled/fsf")

local module7 = require("@luauforge/bundled/fsg")

local module8 = require("@luauforge/bundled/fsh")

local module9 = require("@luauforge/bundled/fsi")

local module10 = require("@luauforge/bundled/fsj")

local defineFastFlag = game:DefineFastFlag("PromptBannerWaitInSmallIntervals", false)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagPasskeyUpsellFilteringEnabled = SharedFlags.FFlagPasskeyUpsellFilteringEnabled
local fFlagUseSignalsForAccountSecurityPrompt = SharedFlags.FFlagUseSignalsForAccountSecurityPrompt
local getAccountSecurityPromptStore

if fFlagUseSignalsForAccountSecurityPrompt then
	getAccountSecurityPromptStore = require("@luauforge/bundled/frE").Stores.GetAccountSecurityPromptStore
else
	getAccountSecurityPromptStore = nil
end

local module12 = require("@luauforge/bundled/fsk")
local module13 = require("@luauforge/bundled/fsm")
local module14 = require("@luauforge/bundled/fsn")
local module15 = require("@luauforge/bundled/fso")
local module16 = require("@luauforge/bundled/fsp")
local module17 = require("@luauforge/bundled/fsr")
local module18 = require("@luauforge/bundled/edO")
local module19 = require("@luauforge/bundled/fss")
local module20 = require("@luauforge/bundled/fst")
local module21 = require("@luauforge/bundled/fsl")
local module22 = require("@luauforge/bundled/ecR")
local React = require(CorePackages.Packages.React)
local module23 = require("@luauforge/bundled/dYT")
local module24 = require("@luauforge/bundled/eda")
local useSheetNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/FoundationFork/Sheet/useSheetNavigation")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module26 = require("@luauforge/bundled/edP")
local module27 = require("@luauforge/bundled/fsu")
local module28 = require("@luauforge/bundled/fsv")
local module29 = require("@luauforge/bundled/fsw")
local module30 = require("@luauforge/bundled/edC")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor

local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local cursorKind = UIBlox.App.SelectionImage.CursorKind
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local withStyle = UIBlox.Style.withStyle

local v5 = nil

local iconsstatusalert = images["icons/status/alert"]
local iconsnavigationclose = images["icons/navigation/close"]

local red = UIBlox.App.Style.Colors.Red

local v6 = {
	[module21.ChangePasswordSuspectedCompromise] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.UnusualActivityDetected",
		descriptionEnd = "Feature.AccountSecurityPrompt.Description.ChangeYourPasswordClickHereStyled",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.UnusualActivity"
	},
	[module21.ChangePasswordBreachedCredential] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.YourPasswordMightBeStolen",
		descriptionEnd = "Feature.AccountSecurityPrompt.Description.NoChangeForceReset",
		descriptionEndSingular = "Feature.AccountSecurityPrompt.Description.NoChangeForceResetSingular",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.ChangeYourPasswordClickHereStyled"
	},
	[module21.AccountRestoresPolicyUpdate] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.AccountRestoresPolicyUpdate",
		descriptionEnd = "Feature.AccountSecurityPrompt.Description.AuthenticatorSetupPromptClickHere",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.AccountRestoresPolicyWithDate",
		settingsTitle = "CommonUI.Features.Label.Settings"
	},
	[module21.AccountRestoresPolicyUpdateV2] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.KeepYourAccountSafeShort",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.AuthenticatorSetupPromptNewShort",
		settingsTitle = "CommonUI.Features.Label.Help"
	},
	[module21.AccountRestoresPolicyUpdateV3] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.AccountRestoresPolicyUpdateV3",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.AccountRestoresPolicyUpdateV3Short",
		settingsTitle = "CommonUI.Features.Label.Settings"
	},
	[module21.Email2SVUpsell] = {
		bannerHeader = "Feature.AccountSecurityPrompt.Header.Email2SVUpsell",
		descriptionStart = "Feature.AccountSecurityPrompt.Description.Email2SVUpsellMessageBody",
		settingsTitle = "CommonUI.Features.Label.Settings"
	}
}

local extended = module22.PureComponent:extend("PromptBannerV2")

extended.defaultProps = { isInteractive = true }

function extended:init()
	self:setState({ requestInFlightForDismissButton = false, forceRenderValue = 0 })

	function self.refreshPromptState()
		self.props.getPromptAssignments(self.props.networking):andThen(function(list)
			local isGeneric = nil
			local v7 = nil
			local metadata = nil

			if fFlagPasskeyUpsellFilteringEnabled then
				list = module12(list)
			end

			if #list > 0 then
				isGeneric = list[1].isGeneric

				v7 = module21.fromRawValue(list[1].promptType)

				if v7 == nil then
					if
						nil == nil
						and typeof(list[1].metadata) == "table"
						and module.fromRawValue(list[1].metadata.displayType) ~= nil
					then
						v7 = list[1].promptType
						metadata = list[1].metadata
					else
						isGeneric = nil
					end
				else
					metadata = list[1].metadata
				end
			end

			if v7 ~= self.props.promptType then
				v5 = nil
			end

			local v8 = module6()

			if v8 >= 0 and v5 ~= nil and v8 <= DateTime.now().UnixTimestamp - v5.UnixTimestamp then
				v5 = nil

				if self.isMounted then
					self:setState({
						forceRenderValue = self.state.forceRenderValue + 1
					})
				end
			end

			self.props.updatePromptType(self.props.analytics, isGeneric, v7, metadata)
		end):catch(function(p2) end):await()
	end

	function self.disablePromptAssignment(p2)
		self:setState({ requestInFlightForDismissButton = true })

		self.props.updatePromptAssignment(
			self.props.networking,
			self.props.promptType,
			p2 and module19.DismissPrompt or module19.DisablePrompt
		):andThen(function()
			self.props.updatePromptType(self.props.analytics, nil, nil, nil)

			self.refreshPromptState()

			spawn(function()
				if not self.isMounted then
					return
				end

				self:setState({ requestInFlightForDismissButton = false })
			end)
		end):catch(function(p3)
			if not self.isMounted then
				return
			end

			self:setState({ requestInFlightForDismissButton = false })
		end)
	end

	function self.handlePrimary(p2)
		return function()
			if self.props.promptType == module21.AccountRestoresPolicyUpdate then
				task.spawn(self.disablePromptAssignment)
				self.props.openWebView(module20.getWebViewUrlAccountSettings(), p2)
			elseif self.props.promptType == module21.AccountRestoresPolicyUpdateV2 then
				task.spawn(self.disablePromptAssignment)
				self.props.openWebView(module20.getWebViewUrlHelpPage(), p2)
			else
				if self.props.promptType == module21.AccountRestoresPolicyUpdateV3 then
					self.props.navigateToSecuritySettings()
					return
				end

				if self.props.promptType == module21.Email2SVUpsell then
					self.props.openWebView(module20.getWebViewUrlEmailHighlight(), p2)
					return
				end

				if self.props.isGeneric then
					return
				end

				self.props.openOverlayWithModalState(module15.ChangePasswordIntro)
			end
		end
	end

	function self.handleDismissOrDisable()
		if
			self.props.promptType == module21.AccountRestoresPolicyUpdate
			or self.props.promptType == module21.AccountRestoresPolicyUpdateV2
			or self.props.promptType == module21.AccountRestoresPolicyUpdateV3
			or self.props.isGeneric
		then
			self.disablePromptAssignment()
		elseif self.props.promptType == module21.Email2SVUpsell then
			self.disablePromptAssignment(true)
		else
			self.props.openOverlayWithModalState(module15.ChangePasswordDismissConfirmation)
		end
	end
end

function extended:didMount()
	self.isMounted = true

	spawn(function()
		while self.isMounted and module3() and module4(self.props.userId) do
			local lastUpdatedPromptTypeAt = self.props.lastUpdatedPromptTypeAt
			local unixTimestampMillis = DateTime.now().UnixTimestampMillis

			local v7 = if self.props.promptType == nil then module7() else module8()

			if lastUpdatedPromptTypeAt == nil then
				self.refreshPromptState()
			else
				local v8 = unixTimestampMillis - lastUpdatedPromptTypeAt.UnixTimestampMillis

				if v7 * 1000 < v8 then
					self.refreshPromptState()
				end
			end

			if defineFastFlag then
				local v8 = os.clock() + v7

				while os.clock() < v8 and self.isMounted do
					wait(1)
				end
			else
				wait(v7)
			end
		end

		if self.isMounted then
			self.props.updatePromptType(self.props.analytics, nil, nil, nil)
		end
	end)
end

function extended:willUnmount()
	self.isMounted = false
end

function extended:wrapInFrame(p3)
	local position = self.props.Position
	local size = self.props.Size
	local v7 = self.props[module22.Change.AbsoluteSize]

	return module22.createElement("Frame", {
		[module22.Change.AbsoluteSize] = v7,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = position,
		Size = size or UDim2.fromScale(1, 0)
	}, p3)
end

function extended:renderInternal()
	local isGeneric = self.props.isGeneric
	local v7 = self.props.promptType
	local metadata = self.props.metadata
	local v8 = not (metadata == nil) and (metadata.showBanner == nil or metadata.showBanner == false)

	local isInteractive = self.props.isInteractive
	local designTokens = self.props.designTokens
	local strokeColor = if designTokens then designTokens.strokeColor else nil
	local cornerRadius = if designTokens then designTokens.cornerRadius else nil

	local requestInFlightForDismissButton = self.state.requestInFlightForDismissButton

	if module2() and not v7 then
		v7 = module21.ChangePasswordSuspectedCompromise
	end

	local v9 = v6[v7]
	local v10 = getFFlagLuaAppAuthenticatorUpsellPopUpEnabled() and v7 == module21.AuthenticatorUpsell
	local v11 = getFFlagLuaAppBroaderAuthenticatorUpsellPopUpEnabled()
		and v7 == module21.BroaderAuthenticatorUpsell
	local v12 = getFFlagLuaAppAccountRestoresPolicyUpsellPopUpEnabled()
		and v7 == module21.AccountRestoresPolicyUpsell
	local v13 = module5() and v7 == module21.Email2SVUpsell

	if isGeneric then
		v9 = (metadata == nil or metadata.bodyResource == nil or metadata.headerResource == nil) and {} or {
			descriptionStart = "Feature.AccountSecurityPrompt." .. metadata.bodyResource,
			bannerHeader = "Feature.AccountSecurityPrompt." .. metadata.headerResource
		}
	elseif v9 == nil and not v10 and not v11 and not v12 and (not v13 or v8) then
		return nil
	end

	local v14 = not isGeneric
	local v15 = v7 ~= module21.ChangePasswordBreachedCredential

	if isGeneric and typeof(metadata) == "table" and metadata.showXButtonForDisable == false then
		v15 = false
	end

	if not isInteractive then
		v15 = false
	end

	local udim = UDim2.new(0, 65, 0, 0)
	local udim2 = UDim2.new(1, -65, 0, 0)

	local v16 = v7 ~= module21.AccountRestoresPolicyUpdateV3

	if isGeneric and typeof(metadata) == "table" and metadata.showAlertIcon == false then
		v16 = false
	end

	if not v16 then
		udim = UDim2.new(0, 0, 0, 0)

		udim2 = UDim2.new(1, v15 and -15 or 0, 0, 0)
	end

	return module22.createElement(module13.Consumer, {
		render = function(p2)
			local v17 = p2 == "Home"
			local v18

			if metadata == nil or metadata.pageRestriction ~= "PAGE_RESTRICTION_HOME_PAGE" then
				v18 = false
			else
				v18 = v17 ~= true
			end

			if v18 then
				return nil
			end

			local v19 = nil

			if v10 or v11 then
				v19 = module15.AuthenticatorUpsellIntro
			elseif v12 then
				v19 = module15.AccountRestoresPolicyUpsell
			elseif v13 and v8 then
				v19 = module15.Email2SVUpsell
			end

			if v19 == nil then
				return withStyle(function(p3)
					local color = p3.Theme.TextLink.Color
					local v20 = string.format(
						"rgb(%d, %d, %d)",
						math.round(color.R * 255),
						math.round(color.G * 255),
						(math.round(color.B * 255))
					)

					return module30(v9)(function(props2)
						if
							props2 == nil
							or props2.bannerHeader == nil
							or props2.bannerHeader == ""
							or props2.descriptionStart == nil
							or props2.descriptionStart == ""
						then
							return nil
						end

						local v21 = props2.descriptionStart:gsub(
							"{styleTagStart}",
							"<font color=\"" .. v20 .. "\">"
						):gsub(
							"{styleTagEnd}",
							"</font>"
						):gsub(
							"{linkStart}",
							"<font color=\"" .. v20 .. "\">"
						):gsub(
							"{linkEnd}",
							"</font>"
						)
						local v22

						if props2.descriptionEnd ~= nil then
							v22 = props2.descriptionEnd:gsub(
									"{styleTagStart}",
									"<font color=\"" .. v20 .. "\">"
								):gsub(
									"{styleTagEnd}",
									"</font>"
								)
								or nil
						end

						local v23 = false

						if v7 == module21.ChangePasswordBreachedCredential then
							v22 = module10(
								props2.descriptionEndSingular,
								props2.descriptionEnd,
								metadata.forceResetTimestamp
							)
						elseif v7 == module21.AccountRestoresPolicyUpdate then
							v21 = v21:gsub(
								"{date}",
								DateTime.fromIsoDate(metadata.accountRestoresPolicyEffectiveTimestamp):FormatUniversalTime(
									"D MMM YYYY",
									LocalizationService.RobloxLocaleId or "en-us"
								)
							)
							v23 = true
						end

						local v24

						if not v7 then
							return v24
						end

						local createElement = module22.createElement
						local activated = module22.Event.Activated
						local v28 = if v14 then self.handlePrimary(props2.settingsTitle) else nil
						local v27 = {
							[activated] = v28,
							AutoButtonColor = isInteractive,
							AutomaticSize = Enum.AutomaticSize.Y,
							BackgroundColor3 = p3.Theme.SystemPrimaryContent.Color,
							BackgroundTransparency = p3.Theme.SystemPrimaryContent.Transparency,
							BorderSizePixel = 0,
							Size = UDim2.fromScale(1, 0),
							Text = "",
							SelectionImageObject = self.props.selectionCursor
						}
						local v29 = {
							Padding = module22.createElement("UIPadding", {
								PaddingLeft = UDim.new(0, 15),
								PaddingRight = UDim.new(0, 15),
								PaddingTop = UDim.new(0, 15),
								PaddingBottom = UDim.new(0, 15)
							}),
							BannerLeftFrame = module22.createElement("Frame", {
								AutomaticSize = Enum.AutomaticSize.Y,
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Size = UDim2.fromScale(v15 and 0.9 or 1, 0)
							}, {
								IconFrame = v16 and module22.createElement(
									"Frame",
									{
										BackgroundTransparency = 0,
										BackgroundColor3 = red,
										BorderSizePixel = 0,
										Size = UDim2.fromOffset(50, 50)
									},
									{
										UICorner = module22.createElement("UICorner", {
											CornerRadius = UDim.new(0, 10)
										}),
										Icon = module22.createElement(imageSetLabel, {
											AnchorPoint = Vector2.new(0.5, 0.5),
											BackgroundTransparency = 1,
											Image = iconsstatusalert,
											Position = UDim2.fromScale(0.5, 0.5),
											Size = UDim2.fromOffset(36, 36)
										})
									}
								),
								HeaderContentFrame = module22.createElement("Frame", {
									AutomaticSize = Enum.AutomaticSize.Y,
									BackgroundTransparency = 1,
									BorderSizePixel = 0,
									Position = udim,
									Size = udim2
								}, {
									ListLayout = module22.createElement("UIListLayout", {
										FillDirection = Enum.FillDirection.Vertical,
										SortOrder = Enum.SortOrder.LayoutOrder
									}),
									Header = module22.createElement(styledTextLabel, {
										layoutOrder = 1,
										automaticSize = Enum.AutomaticSize.Y,
										colorStyle = p3.Theme.SystemPrimaryDefault,
										fontStyle = p3.Font.Header1,
										lineHeight = 1,
										size = UDim2.new(1, 0, 0, 0),
										text = props2.bannerHeader,
										textXAlignment = Enum.TextXAlignment.Left,
										textYAlignment = Enum.TextYAlignment.Top
									}),
									Spacer = module22.createElement("Frame", {
										LayoutOrder = 2,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.fromOffset(0, 15)
									}),
									ContentDescriptionLabel = module22.createElement(styledTextLabel, {
										layoutOrder = 3,
										automaticSize = Enum.AutomaticSize.Y,
										colorStyle = p3.Theme.TextDefault,
										fontStyle = p3.Font.Body,
										lineHeight = 1,
										size = UDim2.new(1, 0, 0, 0),
										text = (v23 or v22 == nil) and v21 or v21 .. " " .. v22,
										textXAlignment = Enum.TextXAlignment.Left,
										textYAlignment = Enum.TextYAlignment.Bottom
									}),
									Spacer2 = v23 and module22.createElement("Frame", {
										LayoutOrder = 4,
										BackgroundTransparency = 1,
										BorderSizePixel = 0,
										Size = UDim2.fromOffset(0, 15)
									}) or nil,
									ContentDescriptionLabel2 = v23 and module22.createElement(styledTextLabel, {
										layoutOrder = 5,
										automaticSize = Enum.AutomaticSize.Y,
										colorStyle = p3.Theme.TextDefault,
										fontStyle = p3.Font.Body,
										lineHeight = 1,
										size = UDim2.new(1, 0, 0, 0),
										text = v22,
										textXAlignment = Enum.TextXAlignment.Left,
										textYAlignment = Enum.TextYAlignment.Bottom
									}) or nil
								})
							}),
							DismissButton = 0,
							UIStroke = 0,
							UICorner = 0
						}

						local v30 = if v15 then requestInFlightForDismissButton and module22.createElement(loading, {
							Position = UDim2.new(1, -15, 0, 15),
							size = iconSize.Medium,
							AnchorPoint = Vector2.new(0.5, 0.5)
						}) or module22.createElement(module27, {
							icon = iconsnavigationclose,
							iconColor = p3.Theme.TextDefault.Color,
							iconPosition = UDim2.new(1, -15, 0, 15),
							iconSize = 28,
							iconTransparency = p3.Theme.TextDefault.Transparency,
							onActivated = self.handleDismissOrDisable,
							Position = UDim2.fromScale(0.9, 0),
							Size = UDim2.new(0.1, 0, 0.5, 0),
							useUIBloxImageSet = true
						}) or nil else nil
						v29.DismissButton = v30

						local v31 = if strokeColor then module22.createElement("UIStroke", {
							ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
							Color = strokeColor.Color3,
							Transparency = strokeColor.Transparency,
							Thickness = 1
						}) else nil
						v29.UIStroke = v31

						local v32 = if cornerRadius then module22.createElement("UICorner", {
							CornerRadius = cornerRadius
						}) else nil
						v29.UICorner = v32
						v24 = {
							BannerFrame = createElement("TextButton", v27, v29)
						} or nil

						return v24
					end)
				end)
			end

			if v5 ~= nil then
				return nil
			end

			local v20 = module9()

			if v20 >= 0 then
				task.delay(v20, function()
					self.props.openOverlayWithModalState(v19)
				end)
			else
				self.props.openOverlayWithModalState(v19)
			end

			v5 = DateTime.now()

			return nil
		end
	})
end

function extended:render()
	return self:wrapInFrame(self:renderInternal())
end

local v7 = useSheetNavigation.connect(function(p2, p3)
	local v9 = if not fFlagUseSignalsForAccountSecurityPrompt then p2.AccountSecurityPrompt.lastUpdatedPromptTypeAt else nil
	local v10 = if not fFlagUseSignalsForAccountSecurityPrompt then p2.AccountSecurityPrompt.isGeneric else nil
	local v11 = if not fFlagUseSignalsForAccountSecurityPrompt then p2.AccountSecurityPrompt.promptType else nil
	local v12 = if not fFlagUseSignalsForAccountSecurityPrompt then p2.AccountSecurityPrompt.metadata else nil
	return {
		lastUpdatedPromptTypeAt = v9,
		isGeneric = v10,
		promptType = v11,
		metadata = v12,
		userId = p2.LocalUserId
	}
end, function(callback)
	return {
		getPromptAssignments = function(p2)
			return callback(module14(p2))
		end,
		openOverlayWithModalState = function(p2)
			return callback(module26(module18.AccountSecurityPromptOverlay, {
				modalState = p2
			}))
		end,
		openWebView = function(p2, p3)
			return callback(module17(p2, p3))
		end,
		navigateToSecuritySettings = function()
			callback(module16())
		end,
		updatePromptType = function(p2, p3, p4, p5)
			return callback(module29(p2, p3, p4, p5))
		end,
		updatePromptAssignment = function(p2, p3, p4)
			return callback(module28(p2, p3, p4))
		end
	}
end)(extended)

if fFlagUseSignalsForAccountSecurityPrompt then
	local v8 = v7
	v7 = React.memo(function(p2)
		local accountSecurityPromptStore = getAccountSecurityPromptStore(false)
		local v9 = useSignalState(accountSecurityPromptStore.getLastUpdatedPromptTypeAt)
		local v10 = useSignalState(accountSecurityPromptStore.getIsGeneric)
		local v11 = useSignalState(accountSecurityPromptStore.getPromptType)
		local v12 = useSignalState(accountSecurityPromptStore.getMetadata)
		return module22.createElement(
			v8,
			Cryo.Dictionary.union(p2, {
				lastUpdatedPromptTypeAt = v9,
				isGeneric = v10,
				promptType = v11,
				metadata = v12
			})
		)
	end)
end

local v8 = roactServices.connect({ analytics = module23, networking = module24 })(v7)

return function(p2)
	local v9 = useSelectionCursor(cursorKind.RoundedRect)
	local v10 = useDesignTokens()

	return module22.createElement(
		v8,
		Cryo.Dictionary.join(p2, {
			designTokens = v10.LuaApps.Banner.securityBanner,
			selectionCursor = v9
		})
	)
end
