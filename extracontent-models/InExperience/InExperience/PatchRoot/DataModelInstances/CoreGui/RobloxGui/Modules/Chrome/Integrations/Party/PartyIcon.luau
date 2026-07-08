local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local Flags = require(Chrome.ChromeShared.Flags)
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local useMappedSignal = require(CorePackages.Workspace.Packages.Chrome).Hooks.useMappedSignal
local usePartyIcon = require(Chrome.Integrations.Party.usePartyIcon)
local MappedSignal = ChromeUtils.MappedSignal
local useTokens = Foundation.Hooks.useTokens
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local SubMenuContext = require(Chrome.ChromeShared.Unibar.SubMenuContext)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider

local function PartyIcon() -- line: 26
	-- upvalues: useTokens (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), MappedSignal (copy), InExperienceAppChatModal (copy), useMappedSignal (copy), usePartyIcon (copy), React (copy), SubMenuContext (copy), Foundation (copy)
	local v17 = useTokens()
	local v18 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_SIZE else UnibarStyle.use().ICON_SIZE
	local v19 = MappedSignal.new(InExperienceAppChatModal.default.visibilitySignal.Event, function(_) -- line: 37
		-- upvalues: InExperienceAppChatModal (copy)
		return InExperienceAppChatModal:getVisible()
	end)
	local v20 = useMappedSignal(v19)
	local v21 = usePartyIcon(v18, 24, not v20 and "icons/menu/2-person-with-bubble" or "icons/menu/2-person-with-bubble-on")
	local v22 = React.useContext(SubMenuContext)

	local function getTransparency(n1: number) -- line: 45
		-- upvalues: v22 (copy)
		if v22 then
			return (v22:map(function(p2) -- line: 47
				-- upvalues: n1 (copy)
				return n1 + (1 - n1) * (1 - p2)
			end))
		end

		return n1
	end

	local createElement = React.createElement
	local View = Foundation.View
	local t1 = {
		Size = UDim2.new(0, v18, 0, v18)
	}
	local t2 = {}
	local createElement2 = React.createElement
	local FoundationImage = Foundation.Image
	local t3 = {
		tag = "anchor-center-center position-center-center radius-circle",
		Size = v21.size:map(function(p3) -- line: 57
			return UDim2.fromOffset(p3, p3)
		end)
	}
	local t4

	if v21.image.backgroundColor then
		t4 = {
			Color3 = v21.image.backgroundColor
		}

		local v33

		if v22 then
			local n2 = 0

			v33 = v22:map(function(p4) -- line: 47
				-- upvalues: n2 (copy)
				return n2 + (1 - n2) * (1 - p4)
			end)
		else
			v33 = 0
		end

		t4.Transparency = v33
	else
		t4 = v17.Color.None
	end

	t3.backgroundStyle = t4
	t3.Image = v21.image.thumbnail

	local t5 = {
		Color3 = v17.Color.Content.Emphasis.Color3
	}
	local EmphasisTransparency = v17.Color.Content.Emphasis.Transparency

	t5.Transparency = if not v22 then EmphasisTransparency else v22:map(function(p5) -- line: 47
		-- upvalues: EmphasisTransparency (copy)
		return EmphasisTransparency + (1 - EmphasisTransparency) * (1 - p5)
	end)
	t3.imageStyle = t5
	t2.Icon = createElement2(FoundationImage, t3)

	local createElement3 = React.createElement
	local View2 = Foundation.View
	local t6 = {
		tag = "anchor-top-right radius-circle size-200 stroke-thicker",
		ZIndex = 2,
		Position = UDim2.new(1, -v17.Stroke.Thicker, 0, v17.Stroke.Thicker)
	}
	local t7 = {
		Color3 = v17.Color.System.Success.Color3
	}
	local SuccessTransparency = v17.Color.System.Success.Transparency

	t7.Transparency = if not v22 then SuccessTransparency else v22:map(function(p6) -- line: 47
		-- upvalues: SuccessTransparency (copy)
		return SuccessTransparency + (1 - SuccessTransparency) * (1 - p6)
	end)
	t6.backgroundStyle = t7

	local t8 = {
		Color = v17.Color.Surface.Surface_0.Color3
	}
	local Surface_0Transparency = v17.Color.Surface.Surface_0.Transparency

	t8.Transparency = if not v22 then Surface_0Transparency else v22:map(function(p7) -- line: 47
		-- upvalues: Surface_0Transparency (copy)
		return Surface_0Transparency + (1 - Surface_0Transparency) * (1 - p7)
	end)
	t8.Thickness = v17.Stroke.Thicker
	t6.stroke = t8
	t2.Badge = createElement3(View2, t6)

	return createElement(View, t1, t2)
end

return PartyIcon
