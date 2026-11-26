local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fIntAXSpawnEffectPlaySeconds = AvatarExperienceFlags.FIntAXSpawnEffectPlaySeconds
local fIntAXSpawnEffectEmitterFadeSeconds = AvatarExperienceFlags.FIntAXSpawnEffectEmitterFadeSeconds
local fIntAXSpawnEffectPreviewPauseSeconds = AvatarExperienceFlags.FIntAXSpawnEffectPreviewPauseSeconds
local fFlagAXSpawnEffectPlayOnEquip = AvatarExperienceFlags.FFlagAXSpawnEffectPlayOnEquip

local class = {}
class.__index = class

local function getCharacterModel(p2)
	return p2.AvatarExperience.AvatarScene.Character.CurrentCharacter
end

local function getEquippedSpawnEffectId(p2)
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets

	if not equippedAssets then
		return nil
	end

	local _97 = equippedAssets["97"]

	if not _97 then
		return nil
	end

	local v5 = next(_97)

	if v5 then
		return (tostring(v5))
	end

	return nil
end

local function disableEmitters(items)
	for k, emitter in items do
		if emitter:IsA("ParticleEmitter") then
			emitter.Enabled = false
		end

		for i, emitter2 in emitter:GetDescendants() do
			if emitter2:IsA("ParticleEmitter") then
				emitter2.Enabled = false
			end
		end
	end
end

local function destroyInstances(items)
	for k, item in items do
		if item and item.Parent then
			item:Destroy()
		end
	end
end

local function teardownInstances(items)
	disableEmitters(items)
	task.delay(fIntAXSpawnEffectEmitterFadeSeconds, function()
		for k, item in items do
			if item and item.Parent then
				item:Destroy()
			end
		end
	end)
end

function class.playEffect(instance, p2)
	local humanoid = instance:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return nil, false
	end

	local success, result = pcall(function()
		return humanoid:PlayAvatarEffectAsync(p2)
	end)

	if success then
		return result, false
	end

	warn("[SpawnEffectManager] PlayAvatarEffectAsync failed: " .. tostring(result))
	return nil, true
end

function class.new(store)
	local object = setmetatable({}, class)

	object.store = store
	object.connections = {}
	object.previewThread = nil
	object.activeEffectInstances = nil
	object.previewGeneration = 0

	if fFlagAXSpawnEffectPlayOnEquip then
		object.pendingEntryEffectId = nil
	end

	return object
end

function class:start()
	local changedConnection = self.store.changed:connect(function(p2, p3)
		local spawnEffectPreview = p2.AvatarExperience.AvatarScene.TryOn.SpawnEffectPreview

		if
			spawnEffectPreview ~= p3.AvatarExperience.AvatarScene.TryOn.SpawnEffectPreview
			or spawnEffectPreview
			and p2.AvatarExperience.AvatarScene.Character.CurrentCharacter ~= p3.AvatarExperience.AvatarScene.Character.CurrentCharacter
		then
			if spawnEffectPreview then
				self.pendingEntryEffectId = nil
				self:startPreview(spawnEffectPreview)
			else
				self:stopPreview()
			end
		end

		if fFlagAXSpawnEffectPlayOnEquip and not spawnEffectPreview then
			local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
			local v5

			if equippedAssets then
				local _97 = equippedAssets["97"]

				if _97 then
					local v6 = next(_97)

					if v6 then
						v5 = tostring(v6)
					end
				end
			end

			local equippedAssets2 = p3.AvatarExperience.AvatarEditor.Character.EquippedAssets
			local v6

			if equippedAssets2 then
				local _97 = equippedAssets2["97"]

				if _97 then
					local v7 = next(_97)

					if v7 then
						v6 = tostring(v7)
					end
				end
			end

			if v5 == v6 then
				if
					self.pendingEntryEffectId
					and p2.AvatarExperience.AvatarScene.Character.CurrentCharacter
				then
					local pendingEntryEffectId = self.pendingEntryEffectId
					self.pendingEntryEffectId = nil

					if pendingEntryEffectId == v5 then
						self:startPreview(pendingEntryEffectId, true)
					end
				end
			else
				self.pendingEntryEffectId = nil

				if v5 then
					self:startPreview(v5, true)
				else
					self:stopPreview()
				end
			end
		end
	end)
	table.insert(self.connections, changedConnection)

	local state = self.store:getState()
	local spawnEffectPreview = state.AvatarExperience.AvatarScene.TryOn.SpawnEffectPreview

	if spawnEffectPreview then
		self:startPreview(spawnEffectPreview)
	elseif fFlagAXSpawnEffectPlayOnEquip then
		local equippedAssets = state.AvatarExperience.AvatarEditor.Character.EquippedAssets
		local v5

		if equippedAssets then
			local _97 = equippedAssets["97"]

			if _97 then
				local v6 = next(_97)

				if v6 then
					v5 = tostring(v6)
				end
			end
		end

		self.pendingEntryEffectId = v5
	end
end

function class:teardownActiveEffect()
	if self.activeEffectInstances then
		local activeEffectInstances = self.activeEffectInstances
		self.activeEffectInstances = nil
		disableEmitters(activeEffectInstances)
		task.delay(fIntAXSpawnEffectEmitterFadeSeconds, function()
			for k, activeEffectInstance in activeEffectInstances do
				if activeEffectInstance and activeEffectInstance.Parent then
					activeEffectInstance:Destroy()
				end
			end
		end)
	end
end

function class:startPreview(p2, p3)
	self:stopPreview()

	local v5 = tonumber(p2)

	if not v5 then
		return
	end

	self.previewGeneration += 1
	local previewGeneration = self.previewGeneration

	self.previewThread = task.spawn(function()
		while previewGeneration == self.previewGeneration do
			local currentCharacter = self.store:getState().AvatarExperience.AvatarScene.Character.CurrentCharacter

			if currentCharacter then
				local v6, v7 = self.playEffect(currentCharacter, v5)

				if previewGeneration == self.previewGeneration then
					if v7 then
						break
					end

					self.activeEffectInstances = v6

					task.wait(fIntAXSpawnEffectPlaySeconds)

					if previewGeneration ~= self.previewGeneration then
						break
					end

					if v6 then
						disableEmitters(v6)
						task.wait(fIntAXSpawnEffectEmitterFadeSeconds)

						for k, v8 in v6 do
							if v8 and v8.Parent then
								v8:Destroy()
							end
						end
					end

					if previewGeneration ~= self.previewGeneration then
						break
					end

					self.activeEffectInstances = nil

					if p3 then
						break
					end
				else
					if not v6 then
						break
					end

					disableEmitters(v6)
					task.delay(fIntAXSpawnEffectEmitterFadeSeconds, function()
						for k, v8 in v6 do
							if v8 and v8.Parent then
								v8:Destroy()
							end
						end
					end)
					break
				end
			end

			task.wait(fIntAXSpawnEffectPreviewPauseSeconds)
		end
	end)
end

function class:stopPreview()
	self.previewGeneration += 1
	self.previewThread = nil
	self:teardownActiveEffect()
end

function class:stop()
	self:stopPreview()

	for k, connection in self.connections do
		connection:disconnect()
	end

	self.connections = {}
end

function class:onDestroy()
	self:stop()
end

return class
