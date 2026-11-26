local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags")
local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")

local splitPaneSlot = AppSplitView.Enums.SplitPaneSlot

local fFlagSplitPaneExperimentVariants = SharedFlags.FFlagSplitPaneExperimentVariants
local fFlagSplitPaneVariantDefaultCollapsed = SharedFlags.FFlagSplitPaneVariantDefaultCollapsed
local fFlagSplitPaneVariantAvatarOnHomeOnly = SharedFlags.FFlagSplitPaneVariantAvatarOnHomeOnly
local fFlagSplitPaneVariantCollapsedAutoOpen = SharedFlags.FFlagSplitPaneVariantCollapsedAutoOpen
local fFlagSplitPaneAvatarOnlyAlwaysExpanded = SharedFlags.FFlagSplitPaneAvatarOnlyAlwaysExpanded

local v5 = {
	name = "DefaultOpen",
	defaultOpen = true,
	autoExpandOnSupportOpen = true,
	avatarOnHome = true,
	supportSlotEligible = true,
	profileSupportSlotEligibleWhenCollapsed = true,
	educationModal = true
}

local v6 = {
	name = "DefaultCollapsed",
	defaultOpen = false,
	autoExpandOnSupportOpen = false,
	avatarOnHome = true,
	supportSlotEligible = true,
	profileSupportSlotEligibleWhenCollapsed = false,
	educationModal = true
}

local v7 = {
	name = "AvatarOnHomeOnly",
	defaultOpen = true,
	autoExpandOnSupportOpen = true,
	avatarOnHome = true,
	supportSlotEligible = false,
	profileSupportSlotEligibleWhenCollapsed = true,
	educationModal = true
}

local v8 = {
	name = "CollapsedAutoOpen",
	defaultOpen = false,
	autoExpandOnSupportOpen = true,
	avatarOnHome = false,
	supportSlotEligible = true,
	profileSupportSlotEligibleWhenCollapsed = true,
	educationModal = false
}

local flag = false
local variantConfig = v5

local function resolveVariant()
	local variant = v5

	if fFlagSplitPaneVariantCollapsedAutoOpen then
		variant = v8
	elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
		variant = v7
	elseif fFlagSplitPaneVariantDefaultCollapsed then
		variant = v6
	end

	flag = true
	variantConfig = variant
	return variant
end

return {
	getVariantConfig = function()
		if flag then
			return variantConfig
		end

		local v9 = v5

		if fFlagSplitPaneVariantCollapsedAutoOpen then
			v9 = v8
		elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
			v9 = v7
		elseif fFlagSplitPaneVariantDefaultCollapsed then
			v9 = v6
		end

		flag = true
		variantConfig = v9

		return variantConfig
	end,
	isPaneCollapsedByDefault = function(): boolean
		if flag then
			return not variantConfig.defaultOpen
		end

		local v9 = v5

		if fFlagSplitPaneVariantCollapsedAutoOpen then
			v9 = v8
		elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
			v9 = v7
		elseif fFlagSplitPaneVariantDefaultCollapsed then
			v9 = v6
		end

		flag = true
		variantConfig = v9

		return not variantConfig.defaultOpen
	end,
	shouldAutoExpandOnSupportOpen = function()
		if flag then
			return variantConfig.autoExpandOnSupportOpen
		end

		local v9 = v5

		if fFlagSplitPaneVariantCollapsedAutoOpen then
			v9 = v8
		elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
			v9 = v7
		elseif fFlagSplitPaneVariantDefaultCollapsed then
			v9 = v6
		end

		flag = true
		variantConfig = v9

		return variantConfig.autoExpandOnSupportOpen
	end,
	isSupportPaneAlwaysExpanded = function(): boolean
		if flag then
			return not variantConfig.supportSlotEligible
		end

		local v9 = v5

		if fFlagSplitPaneVariantCollapsedAutoOpen then
			v9 = v8
		elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
			v9 = v7
		elseif fFlagSplitPaneVariantDefaultCollapsed then
			v9 = v6
		end

		flag = true
		variantConfig = v9

		return not variantConfig.supportSlotEligible
	end,
	shouldCollapseOnSupportClose = function(): boolean
		if flag then
			return not variantConfig.avatarOnHome
		end

		local v9 = v5

		if fFlagSplitPaneVariantCollapsedAutoOpen then
			v9 = v8
		elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
			v9 = v7
		elseif fFlagSplitPaneVariantDefaultCollapsed then
			v9 = v6
		end

		flag = true
		variantConfig = v9

		return not variantConfig.avatarOnHome
	end,
	shouldShowAvatarOnHome = function()
		if flag then
			return variantConfig.avatarOnHome
		end

		local v9 = v5

		if fFlagSplitPaneVariantCollapsedAutoOpen then
			v9 = v8
		elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
			v9 = v7
		elseif fFlagSplitPaneVariantDefaultCollapsed then
			v9 = v6
		end

		flag = true
		variantConfig = v9

		return variantConfig.avatarOnHome
	end,
	isEducationModalEnabled = function()
		if flag then
			return variantConfig.educationModal
		end

		local v9 = v5

		if fFlagSplitPaneVariantCollapsedAutoOpen then
			v9 = v8
		elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
			v9 = v7
		elseif fFlagSplitPaneVariantDefaultCollapsed then
			v9 = v6
		end

		flag = true
		variantConfig = v9

		return variantConfig.educationModal
	end,
	getGameDetailsSplitPaneEligibility = function()
		if not fFlagSplitPaneExperimentVariants then
			return splitPaneSlot.Support
		end

		if not flag then
			local v9 = v5

			if fFlagSplitPaneVariantCollapsedAutoOpen then
				v9 = v8
			elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
				v9 = v7
			elseif fFlagSplitPaneVariantDefaultCollapsed then
				v9 = v6
			end

			flag = true
			variantConfig = v9
		end

		if not variantConfig.supportSlotEligible then
			return nil
		end

		return splitPaneSlot.Support
	end,
	getProfileSplitPaneEligibility = function(p2)
		if not fFlagSplitPaneExperimentVariants then
			return splitPaneSlot.Support
		end

		if not flag then
			local v9 = v5

			if fFlagSplitPaneVariantCollapsedAutoOpen then
				v9 = v8
			elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
				v9 = v7
			elseif fFlagSplitPaneVariantDefaultCollapsed then
				v9 = v6
			end

			flag = true
			variantConfig = v9
		end

		local v9 = variantConfig

		if
			not v9.supportSlotEligible
			or p2 == AppSplitView.Enums.SupportPaneMode.Collapsed
			and not v9.profileSupportSlotEligibleWhenCollapsed
		then
			return nil
		end

		return splitPaneSlot.Support
	end,
	getProfileRoutePresentation = function(p2)
		if fFlagSplitPaneExperimentVariants then
			local support

			if p2 ~= nil then
				if fFlagSplitPaneExperimentVariants then
					if not flag then
						local v9 = v5

						if fFlagSplitPaneVariantCollapsedAutoOpen then
							v9 = v8
						elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
							v9 = v7
						elseif fFlagSplitPaneVariantDefaultCollapsed then
							v9 = v6
						end

						flag = true
						variantConfig = v9
					end

					local v9 = variantConfig

					if
						v9.supportSlotEligible
						and (p2 ~= AppSplitView.Enums.SupportPaneMode.Collapsed or v9.profileSupportSlotEligibleWhenCollapsed)
					then
						support = splitPaneSlot.Support
					end
				else
					support = splitPaneSlot.Support
				end
			end

			local v9 = support ~= nil
			local v10 = not v9

			if v10 then
				if p2 == nil then
					v10 = true
				else
					if not flag then
						local v11 = v5

						if fFlagSplitPaneVariantCollapsedAutoOpen then
							v11 = v8
						elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
							v11 = v7
						elseif fFlagSplitPaneVariantDefaultCollapsed then
							v11 = v6
						end

						flag = true
						variantConfig = v11
					end

					v10 = not variantConfig.defaultOpen

					if v10 then
						if not flag then
							local v11 = v5

							if fFlagSplitPaneVariantCollapsedAutoOpen then
								v11 = v8
							elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
								v11 = v7
							elseif fFlagSplitPaneVariantDefaultCollapsed then
								v11 = v6
							end

							flag = true
							variantConfig = v11
						end

						v10 = not variantConfig.autoExpandOnSupportOpen
					end
				end
			end

			return {
				splitPaneEligibility = support,
				rendersOverlay = v10,
				rendersAboveSplitPane = not (v9 or v10)
			}
		else
			local v10 = if p2 ~= nil then splitPaneSlot.Support else nil
			return {
				splitPaneEligibility = v10,
				rendersOverlay = p2 == nil,
				rendersAboveSplitPane = false
			}
		end
	end,
	getExperienceDetailSplitPaneEligibility = function()
		if not fFlagSplitPaneExperimentVariants or fFlagSplitPaneAvatarOnlyAlwaysExpanded then
			return splitPaneSlot.Support
		end

		if not flag then
			local v9 = v5

			if fFlagSplitPaneVariantCollapsedAutoOpen then
				v9 = v8
			elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
				v9 = v7
			elseif fFlagSplitPaneVariantDefaultCollapsed then
				v9 = v6
			end

			flag = true
			variantConfig = v9
		end

		if not variantConfig.supportSlotEligible then
			return nil
		end

		return splitPaneSlot.Support
	end,
	getDevStoreSeeAllSplitPaneEligibility = function()
		if not fFlagSplitPaneExperimentVariants then
			return splitPaneSlot.Support
		end

		if not flag then
			local v9 = v5

			if fFlagSplitPaneVariantCollapsedAutoOpen then
				v9 = v8
			elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
				v9 = v7
			elseif fFlagSplitPaneVariantDefaultCollapsed then
				v9 = v6
			end

			flag = true
			variantConfig = v9
		end

		if not variantConfig.supportSlotEligible then
			return nil
		end

		return splitPaneSlot.Support
	end,
	getBadgesSeeAllSplitPaneEligibility = function()
		if not fFlagSplitPaneExperimentVariants then
			return splitPaneSlot.Support
		end

		if not flag then
			local v9 = v5

			if fFlagSplitPaneVariantCollapsedAutoOpen then
				v9 = v8
			elseif fFlagSplitPaneVariantAvatarOnHomeOnly then
				v9 = v7
			elseif fFlagSplitPaneVariantDefaultCollapsed then
				v9 = v6
			end

			flag = true
			variantConfig = v9
		end

		if not variantConfig.supportSlotEligible then
			return nil
		end

		return splitPaneSlot.Support
	end,
	variantConfigs = { v5, v6, v7, v8 }
}
