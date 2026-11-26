local module = require("@luauforge/deferred/eil")
local useNavigation = require("@luauforge/deferred/ein").useNavigation
local useLocalization = require("@luauforge/deferred/ejG").Hooks.useLocalization

local appPage = require("@luauforge/deferred/eio").AppPage
local module2 = require("@luauforge/deferred/eiU")

local ampApiProvider = require("@luauforge/deferred/ejN").AmpApiProvider
local accessResponseEnum = require("@luauforge/deferred/ejN").AmpEnums.AccessResponseEnum

local module3 = require("@luauforge/deferred/ejO")

local module4 = require("@luauforge/deferred/eiy")
local module5 = require("@luauforge/deferred/eiD")

local module6 = require("@luauforge/deferred/ejQ")

local module7 = require("@luauforge/deferred/eiz")
local fStringCanAccessTrustedContactsAmpNameSpace = module7.FStringCanAccessTrustedContactsAmpNameSpace
local fStringIsVerified18PlusAmpFeature = module7.FStringIsVerified18PlusAmpFeature

local function TrustedContactsEducationBanner(p2)
	local v5 = module5()
	local v6 = useNavigation()
	local v7, v8, v9 = module6()

	local state, setState = module.useState(accessResponseEnum.Pending)
	module.useEffect(function()
		setState(ampApiProvider.upsellFeatureAccess(
			fStringIsVerified18PlusAmpFeature,
			{},
			fStringCanAccessTrustedContactsAmpNameSpace
		).access)
	end, {})

	local v11 = module.useCallback(function()
		v5(module4.TrustedContactsEducationalBannerClick)

		v6.push(appPage.TrustedContactsEducationModal)
		v8()
	end, { v6, v8, v5 })

	local v12 = module.useCallback(function()
		v5(module4.TrustedContactsEducationalBannerClose)

		v8()
	end, { v8, v5 })

	local v13 = module.useCallback(function()
		v5(module4.TrustedContactsEducationalBannerImpression)

		v9()
	end, { v9, v5 })

	local v14 = useLocalization({
		title = "Feature.Friends.TCEducation.Title",
		bodyText = "Feature.Friends.TFEducation.Banner.Text",
		bodyText18Plus = "Feature.Friends.TFEducation.Modal.TextIntro.EighteenPlus",
		learnMoreLink = "Feature.Friends.LinkText.LearnMore"
	})
	local v15

	if not v7 then
		return v15
	end

	local createElement = module.createElement
	local v17 = {
		layoutOrder = p2.layoutOrder,
		maxWidth = p2.maxWidth,
		onBannerMounted = v13,
		isLoading = state == accessResponseEnum.Pending,
		bannerTitle = v14.title,
		bannerText = 0,
		titleFont = "text-heading-small",
		textFont = "text-body-medium",
		rightCornerButtonIcon = 0,
		rightCornerButtonActivated = 0,
		bigBottomButton = 0
	}
	local v18 = if state == accessResponseEnum.Granted then v14.bodyText18Plus else v14.bodyText
	v17.bannerText = v18

	v17.rightCornerButtonIcon = module2.Enums.IconName.X
	v17.rightCornerButtonActivated = v12

	v17.bigBottomButton = { text = v14.learnMoreLink, onActivated = v11 }
	v15 = createElement(module3, v17)

	return v15
end

return TrustedContactsEducationBanner
