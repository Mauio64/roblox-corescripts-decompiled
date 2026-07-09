local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Parent = script:FindFirstAncestor("AvatarExperienceDebugSections").Parent
local DebugPanel = require(Parent.DebugPanel)
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local AvatarExperienceCommon = require(Parent.AvatarExperienceCommon)
local AvatarExperienceSlotBasedEditor = require(Parent.AvatarExperienceSlotBasedEditor)
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local AvatarEditorSubcategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorSubcategories
local getStaleInventoryGrantStore = AvatarExperienceSlotBasedEditor.Stores.getStaleInventoryGrantStore
local AvatarExperience = Modules.AvatarExperience
local GetAvatarEditorCategories = require(AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local GetAvatarEditorStructure = require(AvatarExperience.AvatarEditor.GetAvatarEditorStructure)
local Hat = AvatarExperienceCommon.Constants.ASSET_TYPE_NAME_TO_ID_STRING.Hat
local color3 = Color3.fromRGB(120, 180, 255)

local function dumpStaleState() -- line: 34
	-- upvalues: getStaleInventoryGrantStore (copy)
	local v28 = getStaleInventoryGrantStore()

	warn("=== [GrantInventoryRefetch] Stale store dump ===")
	warn("stale searchUuids:", v28.getStaleSearchUuids(false))
	warn("=== end dump ===")
end
local function markSearchUuidsStale(t1: {[any]: any}) -- line: 41
	-- upvalues: getStaleInventoryGrantStore (copy)
	local v30 = getStaleInventoryGrantStore()

	for _, v32 in t1 do
		v30.markSearchUuidStale(v32)
	end

	local v33 = getStaleInventoryGrantStore()

	warn("=== [GrantInventoryRefetch] Stale store dump ===")
	warn("stale searchUuids:", v33.getStaleSearchUuids(false))
	warn("=== end dump ===")
end
local function getAllTabSearchUuid() -- line: 49
	-- upvalues: GetAvatarEditorCategories (copy), AvatarEditorCategories (copy)
	for _, v35 in GetAvatarEditorCategories() do
		if v35.Id == AvatarEditorCategories.All and v35.SearchUuid then
			return v35.SearchUuid
		end
	end

	return nil
end
local function getSearchUuidsForAssetType(s1: string) -- line: 58
	-- upvalues: GetAvatarEditorStructure (copy), GetAvatarEditorCategories (copy), AvatarEditorCategories (copy)
	local v37 = GetAvatarEditorStructure().AssetTypeToSearchUuids[s1]
	local g42 = nil
	local SearchUuid = nil
	local v38

	if v37 then
		v38 = table.clone(v37)
	else
		v38 = {}
	end

	for _, v40 in GetAvatarEditorCategories() do
		if v40.Id == AvatarEditorCategories.All and v40.SearchUuid then
			SearchUuid = v40.SearchUuid
			g42 = true
		end

		if g42 then
			break
		end
	end

	if not g42 then
		SearchUuid = nil
	end

	g42 = false

	if SearchUuid then
		for _, v44 in v38 do
			if v44 == SearchUuid then
				return v38
			end
		end

		v38[#v38 + 1] = SearchUuid
	end

	return v38
end
local function findSearchUuidForSubcategoryFilter(s2: string) -- line: 75
	-- upvalues: GetAvatarEditorCategories (copy)
	local function walk(t2: {[any]: any}) -- line: 78
		-- upvalues: s2 (copy), walk (copy)
		for _, v63 in t2 do
			if v63.SubcategoryFilters then
				for _, v65 in v63.SubcategoryFilters do
					if v65.NavigationKey == s2 and v65.SearchUuid then
						return v65.SearchUuid
					end
				end
			end

			if not v63.Subcategories then
				continue
			end

			local v66 = walk(v63.Subcategories)

			if v66 then
				return v66
			end
		end

		return nil
	end

	return (walk((GetAvatarEditorCategories())))
end
local function markHatsCategoryStale() -- line: 100
	-- upvalues: getSearchUuidsForAssetType (copy), Hat (copy), getStaleInventoryGrantStore (copy)
	local v47 = getSearchUuidsForAssetType(Hat)
	local v48 = getStaleInventoryGrantStore()

	for _, v50 in v47 do
		v48.markSearchUuidStale(v50)
	end

	local v51 = getStaleInventoryGrantStore()

	warn("=== [GrantInventoryRefetch] Stale store dump ===")
	warn("stale searchUuids:", v51.getStaleSearchUuids(false))
	warn("=== end dump ===")
end
local function markFullBodyCategoryStale() -- line: 104
	-- upvalues: AvatarEditorSubcategories (copy), GetAvatarEditorCategories (copy), getStaleInventoryGrantStore (copy)
	local FullBody = AvatarEditorSubcategories.FullBody

	local function walk(t3: {[any]: any}) -- line: 78
		-- upvalues: FullBody (copy), walk (copy)
		for _, v69 in t3 do
			if v69.SubcategoryFilters then
				for _, v71 in v69.SubcategoryFilters do
					if v71.NavigationKey == FullBody and v71.SearchUuid then
						return v71.SearchUuid
					end
				end
			end

			if not v69.Subcategories then
				continue
			end

			local v72 = walk(v69.Subcategories)

			if v72 then
				return v72
			end
		end

		return nil
	end

	local v54 = walk((GetAvatarEditorCategories()))

	if not v54 then
		warn("[GrantInventoryRefetch] Full Body SearchUuid not found")

		return
	end

	local v55 = getStaleInventoryGrantStore()

	for _, v57 in { v54 } do
		v55.markSearchUuidStale(v57)
	end

	local v58 = getStaleInventoryGrantStore()

	warn("=== [GrantInventoryRefetch] Stale store dump ===")
	warn("stale searchUuids:", v58.getStaleSearchUuids(false))
	warn("=== end dump ===")
end
local function HarnessButton(t4: {[any]: any}) -- line: 114
	-- upvalues: useTokens (copy), React (copy), View (copy), Foundation (copy), FoundationText (copy)
	local v60 = useTokens()

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, 28),
		LayoutOrder = t4.layoutOrder,
		backgroundStyle = {
			Transparency = 0,
			Color3 = v60.Color.Surface.Surface_300.Color3
		},
		cornerRadius = UDim.new(0, v60.Radius.Small),
		padding = Vector2.new(v60.Padding.Small, 0),
		onActivated = t4.onClick,
		stateLayer = {
			mode = Foundation.Enums.StateLayerMode.Inverse
		}
	}, {
		Label = React.createElement(FoundationText, {
			tag = "text-label-small text-align-x-left",
			Size = UDim2.new(1, 0, 1, 0),
			TextColor3 = t4.accent or v60.Color.Content.Emphasis.Color3,
			Text = t4.text
		})
	})
end
local function GrantInventoryRefetchDebugControls() -- line: 142
	-- upvalues: React (copy), FoundationText (copy), HarnessButton (copy), color3 (copy), markHatsCategoryStale (copy), markFullBodyCategoryStale (copy)
	return React.createElement(React.Fragment, nil, {
		Help = React.createElement(FoundationText, {
			tag = "text-caption-small text-align-x-left content-muted",
			LayoutOrder = 1,
			Text = "Mark a category stale, then open that editor tab to trigger refetch.",
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}),
		MarkHatsStaleButton = React.createElement(HarnessButton, {
			layoutOrder = 2,
			text = "Mark Hats stale",
			accent = color3,
			onClick = markHatsCategoryStale
		}),
		MarkFullBodyStaleButton = React.createElement(HarnessButton, {
			layoutOrder = 3,
			text = "Mark Full Body stale",
			accent = color3,
			onClick = markFullBodyCategoryStale
		})
	})
end

return DebugPanel.registerSection({
	id = "ax.grantInventoryRefetch",
	order = 155,
	defaultCollapsed = true,
	path = {
		"Economy",
		"Marketplace",
		"Grant Inventory Refetch"
	},
	component = GrantInventoryRefetchDebugControls
})
