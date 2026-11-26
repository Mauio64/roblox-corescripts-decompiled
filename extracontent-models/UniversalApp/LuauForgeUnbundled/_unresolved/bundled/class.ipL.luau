local InsertService = game:GetService("InsertService")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module = require("@luauforge/bundled/dPb")

local module2 = require("@luauforge/bundled/dPd")

local module3 = require("@luauforge/bundled/dFs")
local module4 = require("@luauforge/bundled/dPN")
local module5 = require("@luauforge/bundled/fCe")
local module6 = require("@luauforge/bundled/dWC")
local module7 = require("@luauforge/bundled/fCe")
require("@luauforge/bundled/dPs")

local class = {}
class.__index = class

local function isTool(tool)
	return tool:IsA("Tool")
end

local function isScript(Script)
	return Script:IsA("Script")
end

local function disableScripts(tool)
	for i, Script in tool:GetChildren() do
		if Script:IsA("Script") then
			Script.Disabled = true
		end

		disableScripts(Script)
	end
end

local function getToolAssetIdFromOutfitDetails(p2)
	local assets = p2.assets

	if not assets then
		return
	end

	local asset = assets[module4.AssetTypeIdStrings.Gear]

	if asset then
		return asset[1]
	end
end

function class.new(store, animationManager, characterManager)
	local v5 = {}
	setmetatable(v5, class)

	v5.store = store
	v5.characterManager = characterManager
	v5.animationManager = animationManager
	v5.animationManager:setToolManager(v5)
	v5.equippedToolModel = nil
	v5.isCurToolTryOn = false
	v5.destroyed = false
	v5.curToolId = nil
	return v5
end

function class:getEquippedToolModel()
	return self.equippedToolModel
end

function class:checkAndEquipTool()
	local equippedAssets = self.store:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v5 = equippedAssets and equippedAssets[module4.AssetTypeIdStrings.Gear]

	if v5 and next(v5) then
		self:loadAndEquipTool(next(v5), false)
	end
end

function class:checkOutfitAndEquipTool(p2)
	if self.equippedToolModel then
		self:unequipTool()
	end

	local assets = p2.assets
	local v5

	if assets then
		local asset = assets[module4.AssetTypeIdStrings.Gear]

		if asset then
			v5 = asset[1]
		end
	end

	if v5 then
		self:loadAndEquipTool(v5, true)
	end
end

local function shouldHideToolForPPE(p2, p3): boolean
	if p2 and p3 and module5.routeIsProfilePictureEditor(p2) then
		return p2.opaque.name ~= avatarScreen.ProfilePictureEditorFinal
			or p3.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode ~= module6.FullBody
	end

	return false
end

function class:updateAvatarRoute(currentAvatarRoute, p2)
	self.currentAvatarRoute = currentAvatarRoute
	local v5 = currentAvatarRoute.opaque.name == avatarScreen.ProfilePictureEditorFinal
	local v6 = p2.opaque.name == avatarScreen.ProfilePictureEditorFinal
	local routeIsProfilePictureEditor = module5.routeIsProfilePictureEditor(currentAvatarRoute)
	local routeIsProfilePictureEditor2 = module5.routeIsProfilePictureEditor(p2)

	if v5 ~= v6 or routeIsProfilePictureEditor ~= routeIsProfilePictureEditor2 then
		self:update(self.store:getState())
	end
end

function class:update(p2)
	local curToolId = self.curToolId
	local v5 = nil

	for k, tryOnItem in p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems do
		if not tryOnItem.selectedInTryOnManager then
			continue
		end

		if
			tryOnItem.itemType == module4.ItemType.Asset
			and tryOnItem.itemSubType == module4.AssetTypeIdStrings.Gear
		then
			v5 = tryOnItem.itemId
		end

		if not (tryOnItem.itemType == module4.ItemType.Bundle and tryOnItem.bundleInfo) then
			continue
		end

		for k2, v6 in tryOnItem.bundleInfo do
			if v6.assetType == module4.AssetTypeIdStrings.Gear then
				v5 = k2
			end
		end
	end

	local equippedToolId = module7.getEquippedToolId(p2)

	local currentAvatarRoute = self.currentAvatarRoute
	local v6

	if currentAvatarRoute and p2 and module5.routeIsProfilePictureEditor(currentAvatarRoute) then
		v6 = currentAvatarRoute.opaque.name ~= avatarScreen.ProfilePictureEditorFinal
			or p2.AvatarExperience.ProfilePictureEditor.FinalPageViewMode.finalPageViewMode ~= module6.FullBody
	else
		v6 = false
	end

	if v6 then
		self:unequipTool(true)
	elseif v5 then
		self:unequipTool()
		self:loadAndEquipTool(v5, true)
	elseif equippedToolId then
		self:unequipTool(self.curToolIsTryOn)
		self:loadAndEquipTool(equippedToolId, false)
	elseif self.equippedToolModel then
		self:unequipTool(true)
	else
		self.curToolId = nil
	end

	self.checkForChangedTool = self.curToolId ~= nil and self.curToolId ~= curToolId
end

function class:loadAndEquipTool(curToolId, p2)
	self.curToolId = curToolId

	task.spawn(function()
		local v5 = nil
		local success, result = pcall(function()
			v5 = InsertService:LoadAsset(curToolId)
		end)

		if self.destroyed then
			if v5 then
				v5:Destroy()
			end
		elseif result or not v5 then
			warn("Error loading tool in CharacterManager: " .. result)
		elseif curToolId == self.curToolId then
			local v6, tool = next(v5:GetChildren())

			if tool and tool:IsA("Tool") then
				disableScripts(tool)
				self:equipTool(tool)

				if self.checkForChangedTool then
					self.checkForChangedTool = false
					local boundingBox, v7 = self.characterManager:getCurrentCharacter():GetBoundingBox()

					if not (module5.isBoundingBoxVectorSane(v7) and module5.isBoundingBoxCFrameSane(boundingBox)) then
						module3("(Avatar Experience) bad bounding box on adding tool: " .. curToolId)
					end
				end
			end

			if p2 then
				self.curToolIsTryOn = true
				self.store:dispatch(module2())
			else
				self.curToolIsTryOn = false
				self.store:dispatch(module())
			end
		else
			warn("Tool unequipped without getting a chance to get equipped.")
			v5:Destroy()
		end
	end)
end

function class:equipTool(equippedToolModel)
	self.equippedToolModel = equippedToolModel
	self.characterManager:getCurrentCharacter().Humanoid:EquipTool(equippedToolModel)
end

function class:unequipTool(p2)
	self.curToolId = nil
	local equippedToolModel = self.equippedToolModel

	if equippedToolModel then
		if p2 then
			if self.curToolIsTryOn then
				self.store:dispatch(module2())
			else
				self.store:dispatch(module())
			end
		end

		self.equippedToolModel = nil
		self.characterManager:getCurrentCharacter().Humanoid:UnequipTools()
		equippedToolModel:Destroy()
	end
end

function class:notifySwitchedAvatarType()
	if self.equippedToolModel then
		self:equipTool(self.equippedToolModel)
	end
end

function class.start(p2) end

function class:stop()
	local equippedAssets = self.store:getState().AvatarExperience.AvatarEditor.Character.EquippedAssets
	local v5 = equippedAssets and equippedAssets[module4.AssetTypeIdStrings.Gear]

	if not (v5 and next(v5)) and self.equippedToolModel then
		self:unequipTool()
	end

	self:checkAndEquipTool()
end

function class:onDestroy()
	self.destroyed = true
end

return class
