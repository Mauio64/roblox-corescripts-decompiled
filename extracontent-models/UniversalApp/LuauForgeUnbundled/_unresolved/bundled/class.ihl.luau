local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fIntAXSpawnEffectPlaySeconds = AvatarExperienceFlags.FIntAXSpawnEffectPlaySeconds
local fIntAXSpawnEffectEmitterFadeSeconds = AvatarExperienceFlags.FIntAXSpawnEffectEmitterFadeSeconds
local fIntAXSpawnEffectPreviewPauseSeconds = AvatarExperienceFlags.FIntAXSpawnEffectPreviewPauseSeconds

local class = {}
class.__index = class

local function getCharacterModel(p2)
	return p2.AvatarExperience.AvatarScene.Character.CurrentCharacter
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
				self:startPreview(spawnEffectPreview)
			else
				self:stopPreview()
			end
		end
	end)
	table.insert(self.connections, changedConnection)

	local spawnEffectPreview = self.store:getState().AvatarExperience.AvatarScene.TryOn.SpawnEffectPreview

	if spawnEffectPreview then
		self:startPreview(spawnEffectPreview)
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

function class:startPreview(p2)
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
