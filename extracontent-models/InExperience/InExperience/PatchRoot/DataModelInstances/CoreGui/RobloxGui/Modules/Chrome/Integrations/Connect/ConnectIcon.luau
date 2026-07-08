local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local useMappedSignal = require(CorePackages.Workspace.Packages.Chrome).Hooks.useMappedSignal
local usePartyIcon = require(Chrome.Integrations.Party.usePartyIcon)
local MappedSignal = ChromeUtils.MappedSignal
local useTokens = Foundation.Hooks.useTokens
local UnibarStyle = require(CorePackages.Workspace.Packages.Chrome).UnibarStyle
local SubMenuContext = require(Chrome.ChromeShared.Unibar.SubMenuContext)
local InExperienceAppChatModal = require(CorePackages.Workspace.Packages.AppChat.InExperienceAppChatModal)
local getAppChatNavbarItemConfig = require(CorePackages.Workspace.Packages.AppChat.getAppChatNavbarItemConfig)
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(Chrome.ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local ArgoPartyExperimentation = require(CorePackages.Workspace.Packages.SocialExperiments).ArgoPartyExperimentation
local v18 = getAppChatNavbarItemConfig()
local off = v18.icon.off
local on = v18.icon.on
local t1 = {
	integrationId = "",
	shouldShowCustomBadge = true,
	isSquadIndicatorEnabled = false
}

local function ConnectIcon(t2: {[any]: any}) -- line: 45
	-- upvalues: Cryo (copy), t1 (copy), useTokens (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), UnibarStyle (copy), Constants (copy), React (copy), InExperienceAppChatModal (copy), MappedSignal (copy), useMappedSignal (copy), usePartyIcon (copy), on (copy), off (copy), SubMenuContext (copy), Foundation (copy), ArgoPartyExperimentation (copy), v18 (copy)
	local v24 = Cryo.Dictionary.union(t1, t2)
	local v25 = useTokens()
	local v26 = if not FFlagTokenizeUnibarConstantsWithStyleProvider then Constants.ICON_SIZE else UnibarStyle.use().ICON_SIZE
	local v27, v28 = React.useState(InExperienceAppChatModal.default.unreadCount)

	if v24.shouldShowCustomBadge then
		React.useEffect(function() -- line: 60
			-- upvalues: InExperienceAppChatModal (copy), v28 (copy)
			local connection = InExperienceAppChatModal.default.unreadCountSignal.Event:Connect(function(p1) -- line: 61
				-- upvalues: v28 (copy)
				v28(p1)
			end)

			return function() -- line: 64
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, { v28 })
	else
		v27 = 0
	end

	local v29 = nil
	local u30 = nil
	local Success = nil

	if v24.isSquadIndicatorEnabled then
		local v32

		v29, v32 = React.useState(InExperienceAppChatModal.default.currentSquadId)
		u30 = v32
	end

	React.useEffect(function() -- line: 77
		-- upvalues: v24 (copy), InExperienceAppChatModal (copy), u30 (ref)
		if v24.isSquadIndicatorEnabled then
			local connection = InExperienceAppChatModal.default.currentSquadIdSignal.Event:Connect(function(p2) -- line: 80
				-- upvalues: u30 (ref)
				u30(p2)
			end)

			return function() -- line: 84
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end

		return function() -- line: 88
		end
	end, {
		v24.isSquadIndicatorEnabled,
		u30
	})

	if v24.isSquadIndicatorEnabled then
		if v29 ~= "" then
			Success = v25.Color.System.Success
		elseif v27 > 0 then
			Success = v25.Color.System.Contrast
		end
	end

	local v33 = if not v24.isSquadIndicatorEnabled then v27 > 0 else Success
	local v34 = MappedSignal.new(InExperienceAppChatModal.default.visibilitySignal.Event, function(_) -- line: 101
		-- upvalues: InExperienceAppChatModal (copy)
		return InExperienceAppChatModal:getVisible()
	end)
	local v35 = useMappedSignal(v34)
	local v36 = usePartyIcon(v26, 24, if not v35 then off else on)
	local v37 = React.useContext(SubMenuContext)

	local function getTransparency(n1: number) -- line: 109
		-- upvalues: v37 (copy)
		if v37 then
			return (v37:map(function(p4) -- line: 111
				-- upvalues: n1 (copy)
				return n1 + (1 - n1) * (1 - p4)
			end))
		end

		return n1
	end

	local createElement = React.createElement
	local View = Foundation.View
	local t3 = {
		Size = UDim2.new(0, v26, 0, v26)
	}
	local t4 = {}
	local v43

	if ArgoPartyExperimentation.getIsRenameEnabled() then
		v43 = React.createElement(Foundation.Icon, {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			name = v18.icon,
			variant = if not v35 then Foundation.Enums.IconVariant.Regular else Foundation.Enums.IconVariant.Filled
		})
	else
		local createElement2 = React.createElement
		local FoundationImage = Foundation.Image
		local t5 = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = v36.size:map(function(p5) -- line: 130
				return UDim2.fromOffset(p5, p5)
			end)
		}
		local t6

		if v36.image.backgroundColor then
			t6 = {
				Color3 = v36.image.backgroundColor
			}

			local v49

			if v37 then
				local n2 = 0

				v49 = v37:map(function(p6) -- line: 111
					-- upvalues: n2 (copy)
					return n2 + (1 - n2) * (1 - p6)
				end)
			else
				v49 = 0
			end

			t6.Transparency = v49
		else
			t6 = v25.Color.None
		end

		t5.backgroundStyle = t6
		t5.cornerRadius = UDim.new(0, v25.Radius.Circle)
		t5.Image = v36.image.thumbnail

		local t7 = {
			Color3 = v25.Color.Content.Emphasis.Color3
		}
		local EmphasisTransparency = v25.Color.Content.Emphasis.Transparency

		t7.Transparency = if not v37 then EmphasisTransparency else v37:map(function(p7) -- line: 111
			-- upvalues: EmphasisTransparency (copy)
			return EmphasisTransparency + (1 - EmphasisTransparency) * (1 - p7)
		end)
		t5.imageStyle = t7
		v43 = createElement2(FoundationImage, t5)
	end

	t4.Icon = v43

	local v60

	if v33 then
		local createElement3 = React.createElement
		local View2 = Foundation.View
		local t8 = {
			tag = "anchor-top-right radius-circle size-200 stroke-thicker",
			ZIndex = 2,
			Position = UDim2.new(1, -v25.Stroke.Thicker, 0, v25.Stroke.Thicker)
		}
		local t9

		if v24.isSquadIndicatorEnabled then
			t9 = {
				Color3 = Success.Color3
			}

			local SuccessTransparency = Success.Transparency

			t9.Transparency = if not v37 then SuccessTransparency else v37:map(function(p8) -- line: 111
				-- upvalues: SuccessTransparency (copy)
				return SuccessTransparency + (1 - SuccessTransparency) * (1 - p8)
			end)
		else
			t9 = {
				Color3 = v25.Color.System.Contrast.Color3
			}

			local ContrastTransparency = v25.Color.System.Contrast.Transparency

			t9.Transparency = if not v37 then ContrastTransparency else v37:map(function(p9) -- line: 111
				-- upvalues: ContrastTransparency (copy)
				return ContrastTransparency + (1 - ContrastTransparency) * (1 - p9)
			end)
		end

		t8.backgroundStyle = t9

		local t10 = {
			Color = v25.Color.Surface.Surface_0.Color3
		}
		local Surface_0Transparency = v25.Color.Surface.Surface_0.Transparency

		t10.Transparency = if not v37 then Surface_0Transparency else v37:map(function(p10) -- line: 111
			-- upvalues: Surface_0Transparency (copy)
			return Surface_0Transparency + (1 - Surface_0Transparency) * (1 - p10)
		end)
		t10.Thickness = v25.Stroke.Thicker
		t8.stroke = t10
		v60 = createElement3(View2, t8)
	else
		v60 = nil
	end

	t4.Badge = v60

	return createElement(View, t3, t4)
end

return ConnectIcon
