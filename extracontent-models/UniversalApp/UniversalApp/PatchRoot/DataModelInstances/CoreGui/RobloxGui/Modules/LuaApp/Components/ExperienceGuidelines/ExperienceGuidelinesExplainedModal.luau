local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local t = require(CorePackages.Packages.t)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactLocalization = require(Modules.LuaApp.Services.RoactLocalization)
local UIBlox = require(CorePackages.Packages.UIBlox)
local AppLinking = require(CorePackages.Workspace.Packages.RoactServiceTags).AppLinking
local openExternalBrowser = require(Modules.LuaApp.openExternalBrowser)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local NavigateBack = require(Modules.LuaApp.Thunks.NavigateBack)
local AppPage = require(Modules.LuaApp.AppPage)
local ExperienceGuidelinesList = require(Modules.LuaApp.Components.ExperienceGuidelines.ExperienceGuidelinesList)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local AgeRecommendationDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).AgeRecommendations.AgeRecommendationDetails
local ExperienceGuidelinesUrls = require(Modules.LuaApp.Flags.ExperienceGuidelinesUrls)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = require(CorePackages.Workspace.Packages.FocusNavigationUtils).FocusNavigationEventNameEnum
local GetFFlagUseExternalBrowserForAgeGuidelines10ft = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUseExternalBrowserForAgeGuidelines10ft
local v24 = game:DefineFastFlag("FixGuidelinesExplainedClose", false)
local v25 = Roact.PureComponent:extend("ExperienceGuidelinesExplainedModal")

v25.validateProps = t.strictInterface({
	ageRecommendations = t.optional(AgeRecommendationDetails.validateModel),
	ageRecommendationHeader = t.optional(t.string),
	hideCloseButton = t.optional(t.boolean),
	universeId = t.string,
	localization = t.table,
	navigateDown = t.callback,
	navigateBack = t.callback,
	closeModal = t.optional(t.callback),
	screenSize = t.Vector2,
	webViewSupport = t.boolean,
	linking = t.table,
	useExternalBrowserForAgeGuidelines = t.optional(t.boolean)
})

function v25.init(p1) -- line: 52
	-- upvalues: ExperienceGuidelinesUrls (copy), openExternalBrowser (copy), AppPage (copy), TransitionAnimation (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), v24 (copy)
	local FStringExperienceGuidelinesExplainedPageUrl = ExperienceGuidelinesUrls.FStringExperienceGuidelinesExplainedPageUrl

	function p1.onLearnMoreActivated() -- line: 55
		-- upvalues: p1 (copy), openExternalBrowser (copy), FStringExperienceGuidelinesExplainedPageUrl (copy), AppPage (copy), TransitionAnimation (copy)
		if p1.props.useExternalBrowserForAgeGuidelines then
			openExternalBrowser(p1.props.linking, FStringExperienceGuidelinesExplainedPageUrl)

			return
		end

		local localization = p1.props.localization

		p1.props.navigateDown({
			name = AppPage.GenericWebPage,
			detail = FStringExperienceGuidelinesExplainedPageUrl,
			extraProps = {
				title = if not p1.props.ageRecommendationHeader then localization:Format("Feature.GameDetails.Label.ContentMaturity") else p1.props.ageRecommendationHeader,
				transitionAnimation = TransitionAnimation.SlideInFromRight
			}
		})
	end
	function p1.closeModal() -- line: 73
		-- upvalues: p1 (copy)
		if p1.props.closeModal then
			p1.props.closeModal()

			return
		end

		p1.props.navigateBack()
	end

	p1.focusEventHandlers = {
		[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p2) -- line: 83
				-- upvalues: v24 (copy), p1 (copy)
				if v24 then
					if not p1.props.hideCloseButton then
						p1.closeModal()
						p2:cancel()

						return
					end
				else
					p1.closeModal()
					p2:cancel()
				end
			end)
		}
	}
end
function v25.render(p3) -- line: 98
	-- upvalues: Roact (copy), PartialPageModal (copy), ButtonType (copy), ExperienceGuidelinesList (copy)
	local localization = p3.props.localization
	local ageRecommendations = p3.props.ageRecommendations
	local screenSize = p3.props.screenSize
	local v34 = Roact.createElement(PartialPageModal, {
		title = if not p3.props.ageRecommendationHeader then localization:Format("Feature.GameDetails.Label.ContentMaturity") else p3.props.ageRecommendationHeader,
		screenSize = screenSize,
		onCloseClicked = if not p3.props.hideCloseButton then p3.closeModal else nil,
		buttonStackProps = if not p3.props.webViewSupport then nil else {
			buttonHeight = 48,
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = {{
				buttonType = ButtonType.Secondary,
				props = {
					isDisabled = false,
					onActivated = p3.onLearnMoreActivated,
					text = localization:Format("Feature.GameDetails.Label.LearnMore")
				}
			}}
		}
	}, {
		ViewFrame = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			DescriptorList = ageRecommendations and Roact.createElement(ExperienceGuidelinesList, {
				ageRecommendations = ageRecommendations
			})
		})
	})

	return Roact.createElement("ImageButton", {
		AutoButtonColor = false,
		ImageTransparency = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0),
		Selectable = p3.props.hideCloseButton
	}, {
		Content = v34
	})
end

local v26 = RoactRodux.connect(function(p4, p5) -- line: 154
	return {
		screenSize = p4.ScreenSize,
		ageRecommendations = p4.AgeRecommendations[p5.universeId],
		ageRecommendationHeader = p4.AgeRecommendationHeaders.headerDisplayName
	}
end, function(p6) -- line: 160
	-- upvalues: NavigateDown (copy), NavigateBack (copy)
	return {
		navigateDown = function(p7) -- line: 162
			-- upvalues: p6 (copy), NavigateDown (copy)
			return p6(NavigateDown(p7))
		end,
		navigateBack = function() -- line: 165
			-- upvalues: p6 (copy), NavigateBack (copy)
			return p6(NavigateBack())
		end
	}
end)(v25)
local v27 = RoactServices.connect({
	localization = RoactLocalization,
	linking = AppLinking
})(v26)

return (RoactAppPolicy.connect(function(p8) -- line: 176
	-- upvalues: GetFFlagUseExternalBrowserForAgeGuidelines10ft (copy)
	local v39 = p8.getWebViewSupport()
	local v40 = if not GetFFlagUseExternalBrowserForAgeGuidelines10ft() then nil else p8.getUseExternalBrowserForAgeGuidelines()

	return {
		webViewSupport = v39,
		useExternalBrowserForAgeGuidelines = v40
	}
end)(v27))
