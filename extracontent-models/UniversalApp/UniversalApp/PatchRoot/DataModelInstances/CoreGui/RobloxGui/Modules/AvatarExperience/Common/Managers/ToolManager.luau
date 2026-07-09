local InsertService = game:GetService("InsertService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Modules = CoreGui.RobloxGui.Modules
local IncrementCharacterModelVersion = require(Modules.AvatarExperience.AvatarEditor.Actions.IncrementCharacterModelVersion)
local IncrementTryOnCharacterModelVersion = require(Modules.AvatarExperience.Catalog.Actions.IncrementTryOnCharacterModelVersion)
local mutedError = require(Modules.LuaApp.mutedError)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local PPEThumbnailType = require(Modules.AvatarExperience.ProfilePictureEditor.PPEThumbnailType)
local Utils2 = require(Modules.AvatarExperience.Common.Utils)

require(Modules.AvatarExperience.Common.Types)

local t1 = {}

t1.__index = t1

local function isTool(p1) -- line: 26
	return p1:IsA("Tool")
end
local function isScript(p2) -- line: 30
	return p2:IsA("Script")
end
local function disableScripts(p3) -- line: 34
	-- upvalues: disableScripts (copy)
	for _, child in p3:GetChildren() do
		if child:IsA("Script") then
			child.Disabled = true
		end

		disableScripts(child)
	end
end
local function getToolAssetIdFromOutfitDetails(p4) -- line: 44
	-- upvalues: Constants (copy)
	local assets = p4.assets

	if not assets then
		return
	end

	local v26 = assets[Constants.AssetTypeIdStrings.Gear]

	if not v26 then
		return
	end

	return v26[1]
end

function t1.new(p5, p6, p7) -- line: 58
	-- upvalues: t1 (copy)
	local t2 = {}

	setmetatable(t2, t1)
	t2.store = p5
	t2.characterManager = p7
	t2.animationManager = p6
	t2.animationManager:setToolManager(t2)
	t2.equippedToolModel = nil
	t2.isCurToolTryOn = false
	t2.destroyed = false
	t2.curToolId = nil

	return t2
end
function t1.getEquippedToolModel(p8) -- line: 73
	return p8.equippedToolModel
end
function t1.checkAndEquipTool(p9) -- line: 80
	-- upvalues: Constants (copy)
	local EquippedAssets = p9.store:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v34 = EquippedAssets and EquippedAssets[Constants.AssetTypeIdStrings.Gear]

	if v34 and next(v34) then
		p9:loadAndEquipTool(next(v34), false)
	end
end
function t1.checkOutfitAndEquipTool(p10, p11) -- line: 93
	-- upvalues: Constants (copy)
	if p10.equippedToolModel then
		p10:unequipTool()
	end

	local assets = p11.assets
	local v38

	if not assets then
		v38 = nil
	else
		local v39 = assets[Constants.AssetTypeIdStrings.Gear]

		v38 = if v39 then v39[1] else nil
	end

	if v38 then
		p10:loadAndEquipTool(v38, true)
	end
end

local function shouldHideToolForPPE(p12, p13) -- line: 104
	-- upvalues: Utils (copy), AvatarScreen (copy), PPEThumbnailType (copy)
	if not p12 or not p13 then
		return false
	end

	if not Utils.routeIsProfilePictureEditor(p12) then
		return false
	end

	if p12.opaque.name == AvatarScreen.ProfilePictureEditorFinal and p13.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode == PPEThumbnailType.FullBody then
		return false
	end

	return true
end

function t1.updateAvatarRoute(p14, p15, p16) -- line: 122
	-- upvalues: AvatarScreen (copy), Utils (copy)
	p14.currentAvatarRoute = p15

	local v45 = p15.opaque.name == AvatarScreen.ProfilePictureEditorFinal
	local v46 = p16.opaque.name == AvatarScreen.ProfilePictureEditorFinal
	local v47 = Utils.routeIsProfilePictureEditor(p15)
	local v48 = Utils.routeIsProfilePictureEditor(p16)

	if v45 ~= v46 or v47 ~= v48 then
		p14:update(p14.store:getState())
	end
end
function t1.update(p17, p18) -- line: 136
	-- upvalues: Constants (copy), Utils2 (copy), Utils (copy), AvatarScreen (copy), PPEThumbnailType (copy)
	local curToolId = p17.curToolId
	local itemId = nil

	for _, v54 in p18.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if v54.selectedInTryOnManager then
			if v54.itemType == Constants.ItemType.Asset and v54.itemSubType == Constants.AssetTypeIdStrings.Gear then
				itemId = v54.itemId
			end

			if v54.itemType == Constants.ItemType.Bundle and v54.bundleInfo then
				for v55, v56 in v54.bundleInfo do
					if v56.assetType == Constants.AssetTypeIdStrings.Gear then
						itemId = v55
					end
				end
			end
		end
	end

	local v57 = Utils2.getEquippedToolId(p18)
	local currentAvatarRoute = p17.currentAvatarRoute

	if not not currentAvatarRoute and if p18 then if Utils.routeIsProfilePictureEditor(currentAvatarRoute) then currentAvatarRoute.opaque.name ~= AvatarScreen.ProfilePictureEditorFinal or p18.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode ~= PPEThumbnailType.FullBody else false else false then
		p17:unequipTool(true)
	elseif itemId then
		p17:unequipTool()
		p17:loadAndEquipTool(itemId, true)
	elseif v57 then
		p17:unequipTool(p17.curToolIsTryOn)
		p17:loadAndEquipTool(v57, false)
	elseif p17.equippedToolModel then
		p17:unequipTool(true)
	else
		p17.curToolId = nil
	end

	p17.checkForChangedTool = p17.curToolId ~= nil and curToolId ~= p17.curToolId
end
function t1.loadAndEquipTool(p19, p20, p21) -- line: 186
	-- upvalues: InsertService (copy), disableScripts (copy), Utils (copy), mutedError (copy), IncrementCharacterModelVersion (copy), IncrementTryOnCharacterModelVersion (copy)
	p19.curToolId = p20
	task.spawn(function() -- line: 189
		-- upvalues: InsertService (copy), p20 (copy), p19 (copy), disableScripts (copy), Utils (copy), mutedError (copy), p21 (copy), IncrementCharacterModelVersion (copy), IncrementTryOnCharacterModelVersion (copy)
		local u73 = nil
		local _, result = pcall(function() -- line: 191
			-- upvalues: u73 (ref), InsertService (copy), p20 (copy)
			u73 = InsertService:LoadAsset(p20)
		end)

		if p19.destroyed then
			if u73 then
				u73:Destroy()
			end

			return
		end

		if result or not u73 then
			warn("Error loading tool in CharacterManager: " .. result)

			return
		end

		if p20 ~= p19.curToolId then
			warn("Tool unequipped without getting a chance to get equipped.")
			u73:Destroy()

			return
		end

		local _, v77 = next(u73:GetChildren())

		if v77 and v77:IsA("Tool") then
			disableScripts(v77)
			p19:equipTool(v77)

			if p19.checkForChangedTool then
				p19.checkForChangedTool = false

				local v78, v79 = p19.characterManager:getCurrentCharacter():GetBoundingBox()

				if not Utils.isBoundingBoxVectorSane(v79) or not Utils.isBoundingBoxCFrameSane(v78) then
					mutedError("(Avatar Experience) bad bounding box on adding tool: " .. p20)
				end
			end
		end

		if not p21 then
			p19.curToolIsTryOn = false
			p19.store:dispatch(IncrementCharacterModelVersion())
		else
			p19.curToolIsTryOn = true
			p19.store:dispatch(IncrementTryOnCharacterModelVersion())
		end
	end)
end
function t1.equipTool(p22, p23) -- line: 243
	p22.equippedToolModel = p23
	p22.characterManager:getCurrentCharacter().Humanoid:EquipTool(p23)
end
function t1.unequipTool(p24, p25) -- line: 248
	-- upvalues: IncrementTryOnCharacterModelVersion (copy), IncrementCharacterModelVersion (copy)
	p24.curToolId = nil

	local equippedToolModel = p24.equippedToolModel

	if equippedToolModel then
		if p25 then
			if p24.curToolIsTryOn then
				p24.store:dispatch(IncrementTryOnCharacterModelVersion())
			else
				p24.store:dispatch(IncrementCharacterModelVersion())
			end
		end

		p24.equippedToolModel = nil
		p24.characterManager:getCurrentCharacter().Humanoid:UnequipTools()
		equippedToolModel:Destroy()
	end
end
function t1.notifySwitchedAvatarType(p26) -- line: 266
	if p26.equippedToolModel then
		p26:equipTool(p26.equippedToolModel)
	end
end
function t1.start(_) -- line: 272
end
function t1.stop(p28) -- line: 274
	-- upvalues: Constants (copy)
	local EquippedAssets = p28.store:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v71 = EquippedAssets and EquippedAssets[Constants.AssetTypeIdStrings.Gear]

	if (not v71 or not next(v71)) and p28.equippedToolModel then
		p28:unequipTool()
	end

	p28:checkAndEquipTool()
end
function t1.onDestroy(p29) -- line: 285
	p29.destroyed = true
end

return t1
