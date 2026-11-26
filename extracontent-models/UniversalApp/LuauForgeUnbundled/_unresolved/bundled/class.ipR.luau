local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/fCe")
local module2 = require("@luauforge/bundled/fCI")
local module3 = require("@luauforge/bundled/dPN")

local class = {}
class.__index = class

function class.new(store, avatarRoute)
	local v5 = {}
	setmetatable(v5, class)

	v5.connections = {}
	v5.store = store
	v5.avatarRoute = avatarRoute

	v5.avatarSwapPFX = {}

	for i = 1, 4 do
		table.insert(v5.avatarSwapPFX, ReplicatedStorage:WaitForChild("AvatarSwap-PFX"):Clone())
	end

	v5.emissionId = 0

	v5.destroyed = false

	return v5
end

function class:setAvatarRoute(avatarRoute)
	self.avatarRoute = avatarRoute
end

function class:start()
	for k, v5 in self.avatarSwapPFX do
		v5.Parent = Workspace
		v5.MainEmitter.Rate = 10
		v5.MediumEmitter.MediumEmissions.Rate = 20
		v5.SmallerEmitter.SmallerEmissions.Rate = 20
	end

	local changedConnection = self.store.changed:connect(function(p2, p3)
		self:update(p2, p3)
	end)
	table.insert(self.connections, changedConnection)

	self.oldAccessories = {}
	self.changedAccessories = {}
	self.curCharacter = nil
	self.accessoryPositions = {}
end

function class:stop()
	for k, v5 in self.avatarSwapPFX do
		v5.Parent = ReplicatedStorage
	end

	for k, connection in self.connections do
		connection:disconnect()
	end

	self.connections = {}
end

local next2 = next
function class:getAttachmentOrPartPosition(p3)
	local avatarType = self.store:getState().AvatarExperience.AvatarEditor.Character.AvatarType
	local v5 = module3.AssetTypeIdToPartsAndAttachments[avatarType][p3]

	if v5 == nil then
		return nil
	end

	local positions = {}

	for k, v6 in v5 do
		local v7

		if v6 then
			v7 = v6.Attachment and module.getAttachmentCFrame(self.curCharacter, v6.Part, v6.Attachment)
				or module.getPartCFrame(self.curCharacter, v6.Part)
				or nil
		end

		if v7 ~= nil and v7.Position ~= nil then
			table.insert(positions, v7.Position)
		end
	end

	return positions
end

function class:getChangedTryOnPart(p2, p3)
	local lastToggledItem = p3.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem or {}
	local lastToggledItem2 = p2.AvatarExperience.AvatarScene.OutfitTryOn.LastToggledItem or {}

	if lastToggledItem2 == lastToggledItem then
		return nil, nil
	end

	return
		lastToggledItem2.itemId or lastToggledItem.itemId,
		self:getAttachmentOrPartPosition(lastToggledItem2.itemSubType or lastToggledItem.itemSubType)
end

function class:getChangedEquippedPart(p2, p3)
	local equippedAssets = p3.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
	local equippedAssets2 = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets or {}
	local v5, v6 = next2((module2.getEquippedDiffs(equippedAssets2, equippedAssets)))

	if v5 then
		return v6[1], self:getAttachmentOrPartPosition(v5)
	end

	return nil, nil
end

function class:setPositions(items)
	for k, item in items do
		if k > 4 then
			break
		end

		self.avatarSwapPFX[k].Position = item
		self.avatarSwapPFX[k].MediumEmitter.Position = item
		self.avatarSwapPFX[k].SmallerEmitter.Position = item
	end
end

function class:getChangedAttachmentPosition(p2, p3)
	if next2(self.changedAccessories) then
		local accessoryPositions = {}
		local changedAccessories = {}

		for k, changedAccessory in self.changedAccessories do
			local accessoryPosition = self.accessoryPositions[changedAccessory.accessory.Name]

			if accessoryPosition then
				table.insert(accessoryPositions, accessoryPosition)

				if changedAccessory.removed then
					self.accessoryPositions[changedAccessory.accessory.Name] = nil
				end
			elseif not changedAccessory.removed then
				table.insert(changedAccessories, changedAccessory)
			end
		end

		self.changedAccessories = changedAccessories
		return accessoryPositions
	else
		local changedEquippedPart, v5 = self:getChangedEquippedPart(p2, p3)

		if not v5 then
			local v6
			v6, v5 = self:getChangedTryOnPart(p2, p3)
		end

		return v5
	end
end

function class:getAccessories(p3)
	return (self.curCharacter:FindFirstChildOfClass("Humanoid"):GetAccessories())
end

function class:cachePosition(instance)
	local basePart = instance:FindFirstChildWhichIsA("BasePart")

	if basePart then
		self.accessoryPositions[instance.Name] = basePart.Position
	end

	return basePart
end

function class:updateChangedAccessory(p2)
	local accessories = self:getAccessories(p2)
	local diffList = module2.diffList(accessories, self.oldAccessories)
	local oldAccessories = self.oldAccessories
	local mapped = Cryo.List.map(diffList, function(p3)
		if Cryo.List.find(oldAccessories, p3) then
			return { accessory = p3, removed = true }
		end

		return { accessory = p3, removed = false }
	end)

	self.changedAccessories = Cryo.List.join(self.changedAccessories, mapped)

	for k, changedAccessory in self.changedAccessories do
		if not self.accessoryPositions[changedAccessory.accessory.Name] then
			self:cachePosition(changedAccessory.accessory)
		end
	end

	self.oldAccessories = accessories
end

function class:update(p2, p3)
	if not p2.AvatarExperience.AvatarScene.Character.CurrentCharacter then
		return
	end

	self.curCharacter = p2.AvatarExperience.AvatarScene.Character.CurrentCharacter
	self:updateChangedAccessory(p2)

	local v5 = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets ~= p3.AvatarExperience.AvatarEditor.Character.EquippedAssets

	local v6 = p2.AvatarExperience.AvatarEditor.Character.AvatarType ~= p3.AvatarExperience.AvatarEditor.Character.AvatarType

	local v7 = p2.AvatarExperience.AvatarEditor.Character.BodyColors ~= p3.AvatarExperience.AvatarEditor.Character.BodyColors

	local v8 = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems ~= p3.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems

	local name = self.avatarRoute.opaque.name

	if
		name == "ProfilePictureEditorEmotes"
		or name == "ProfilePictureEditorCamera"
		or name == "ProfilePictureEditorFinal"
	then
		for i = 1, #self.avatarSwapPFX do
			self.avatarSwapPFX[i].MainEmitter.Enabled = false
			self.avatarSwapPFX[i].MediumEmitter.MediumEmissions.Enabled = false
			self.avatarSwapPFX[i].SmallerEmitter.SmallerEmissions.Enabled = false
		end
	elseif v5 or v6 or v7 or v8 or next2(self.changedAccessories) then
		local changedAttachmentPosition = self:getChangedAttachmentPosition(p2, p3)

		if changedAttachmentPosition and next2(changedAttachmentPosition) then
			self:setPositions(changedAttachmentPosition)
			self:runParticleEmitter(#changedAttachmentPosition)
		end
	end
end

function class:runParticleEmitter(p2)
	task.spawn(function()
		local v5 = math.min(p2, 4)

		for k, v6 in self.avatarSwapPFX do
			if v5 < k then
				v6.MainEmitter.Enabled = false
				v6.MediumEmitter.MediumEmissions.Enabled = false
				v6.SmallerEmitter.SmallerEmissions.Enabled = false
			else
				v6.MainEmitter.Enabled = true
				v6.MediumEmitter.MediumEmissions.Enabled = true
				v6.SmallerEmitter.SmallerEmissions.Enabled = true
			end
		end

		self.emissionId += 1
		local emissionId = self.emissionId

		task.wait(0.3)

		if self.destroyed then
			return
		end

		if self.emissionId == emissionId then
			for i = 1, v5 do
				self.avatarSwapPFX[i].MainEmitter.Enabled = false
				self.avatarSwapPFX[i].MediumEmitter.MediumEmissions.Enabled = false
				self.avatarSwapPFX[i].SmallerEmitter.SmallerEmissions.Enabled = false
			end
		end
	end)
end

function class:onDestroy()
	self.avatarSwapPFX[1]:Destroy()
	self.avatarSwapPFX[2]:Destroy()
	self.avatarSwapPFX[3]:Destroy()
	self.avatarSwapPFX[4]:Destroy()

	self.destroyed = true
end

return class
