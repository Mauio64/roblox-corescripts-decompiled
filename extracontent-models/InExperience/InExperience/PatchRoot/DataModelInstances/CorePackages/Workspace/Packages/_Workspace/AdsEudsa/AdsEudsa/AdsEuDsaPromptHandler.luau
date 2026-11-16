local AdService = game:GetService("AdService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")

local parent = script.Parent.Parent
local Roact = require(parent.Roact)

local Foundation = require(parent.Foundation)
local ColorMode = Foundation.Enums.ColorMode

local UIBlox = require(parent.UIBlox)

local AdsEuDsaPromptUI = require(script.Parent.AdsEuDsaPromptUI)

local RobloxTranslator = require(parent.RobloxTranslator)

local function getBodyText(advertiserName, payerName)
	if advertiserName ~= "" and payerName == "" then
		return RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.InExperienceDisclosureDynamic", {
			AdvertiserName = advertiserName
		})
	end

	if advertiserName == "" or payerName == "" then
		return RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.InExperienceDisclosureStatic")
	end

	return RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.InExperienceDisclosureDynamicWithPayer", {
		AdvertiserName = advertiserName,
		PayerName = payerName
	})
end

local extended = Roact.PureComponent:extend("AdsEuDsaPromptHandler")

function extended:init()
	self:setState({ enabled = false })

	self.savedSelectedCoreObject = nil

	self:setState({ bodyText = "" })

	AdService.ShowDynamicEudsaDisclosure:Connect(function(advertiserName, payerName)
		self:setState({
			bodyText = getBodyText(advertiserName, payerName)
		})

		self:showPrompt()
	end)
end

function extended:saveSelectedObject()
	self.savedSelectedCoreObject = GuiService.SelectedCoreObject
	GuiService.SelectedCoreObject = nil
end

function extended:restoreSelectedObject()
	if self.savedSelectedCoreObject == nil or self.savedSelectedCoreObject:IsDescendantOf(CoreGui) then
		GuiService.SelectedCoreObject = self.savedSelectedCoreObject
	end
end

function extended:showPrompt()
	self:saveSelectedObject()
	self:setState({ enabled = true })
end

function extended:hidePrompt()
	self:setState({ enabled = false })

	AdService:HideEudsaDisclosure()
	self:restoreSelectedObject()
end

function extended.render(handler)
	if not handler.state.enabled then
		return nil
	end

	local appStyleProvider = UIBlox.App.Style.AppStyleProvider
	local constants = UIBlox.App.Style.Constants
	local v = {
		Dark = { themeName = ColorMode.Dark, fontName = constants.FontName.Gotham }
	}

	local element = Roact.createElement(AdsEuDsaPromptUI, {
		handler = handler,
		bodyText = handler.state.bodyText
	})

	return (Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 15,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		AutoLocalize = false,
		Enabled = handler.state.enabled
	}, Roact.createElement(appStyleProvider, { style = v.Dark }, {
		Frame = Roact.createElement("Frame", {
			Selectable = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			Prompt = element,
			ModalFix = Roact.createElement("ImageButton", {
				BackgroundTransparency = 0,
				Modal = true,
				Size = UDim2.new(0, 0, 0, 0)
			})
		})
	})))
end

return extended
