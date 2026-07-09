local AdService = game:GetService("AdService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local Roact = require(ParentParent.Roact)
local UIBlox = require(ParentParent.UIBlox)
local AdsEuDsaPromptUI = require(script.Parent.AdsEuDsaPromptUI)
local RobloxTranslator = require(ParentParent.RobloxTranslator)

local function getBodyText(p1, p2) -- line: 15
	-- upvalues: RobloxTranslator (copy)
	if p1 ~= "" and p2 == "" then
		return RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.InExperienceDisclosureDynamic", {
			AdvertiserName = p1
		})
	end

	if p1 ~= "" and p2 ~= "" then
		return RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.InExperienceDisclosureDynamicWithPayer", {
			AdvertiserName = p1,
			PayerName = p2
		})
	end

	return RobloxTranslator:FormatByKey("CoreScripts.Ads.Label.InExperienceDisclosureStatic")
end

local v10 = Roact.PureComponent:extend("AdsEuDsaPromptHandler")

function v10.init(p3) -- line: 32
	-- upvalues: AdService (copy), getBodyText (copy)
	p3:setState({
		enabled = false
	})
	p3.savedSelectedCoreObject = nil
	p3:setState({
		bodyText = ""
	})
	AdService.ShowDynamicEudsaDisclosure:Connect(function(p4, p5) -- line: 42
		-- upvalues: p3 (copy), getBodyText (copy)
		p3:setState({
			bodyText = getBodyText(p4, p5)
		})
		p3:showPrompt()
	end)
end
function v10.saveSelectedObject(p6) -- line: 50
	-- upvalues: GuiService (copy)
	p6.savedSelectedCoreObject = GuiService.SelectedCoreObject
	GuiService.SelectedCoreObject = nil
end
function v10.restoreSelectedObject(p7) -- line: 55
	-- upvalues: CoreGui (copy), GuiService (copy)
	if p7.savedSelectedCoreObject == nil or p7.savedSelectedCoreObject:IsDescendantOf(CoreGui) then
		GuiService.SelectedCoreObject = p7.savedSelectedCoreObject
	end
end
function v10.showPrompt(p8) -- line: 62
	p8:saveSelectedObject()
	p8:setState({
		enabled = true
	})
end
function v10.hidePrompt(p9) -- line: 69
	-- upvalues: AdService (copy)
	p9:setState({
		enabled = false
	})
	AdService:HideEudsaDisclosure()
	p9:restoreSelectedObject()
end
function v10.render(p10) -- line: 77
	-- upvalues: UIBlox (copy), Roact (copy), AdsEuDsaPromptUI (copy)
	if not p10.state.enabled then
		return nil
	end

	local AppStyleProvider = UIBlox.App.Style.AppStyleProvider
	local Constants = UIBlox.App.Style.Constants
	local Dark = Constants.ThemeName.Dark
	local Gotham = Constants.FontName.Gotham
	local t1 = {
		Dark = {
			themeName = Dark,
			fontName = Gotham
		}
	}
	local v24 = Roact.createElement(AdsEuDsaPromptUI, {
		handler = p10,
		bodyText = p10.state.bodyText
	})

	return (Roact.createElement("ScreenGui", {
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 15,
		AutoLocalize = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Enabled = p10.state.enabled
	}, Roact.createElement(AppStyleProvider, {
		style = t1.Dark
	}, {
		Frame = Roact.createElement("Frame", {
			Selectable = false,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			Prompt = v24,
			ModalFix = Roact.createElement("ImageButton", {
				BackgroundTransparency = 0,
				Modal = true,
				Size = UDim2.new(0, 0, 0, 0)
			})
		})
	})))
end

return v10
