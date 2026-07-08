local InsertService = game:GetService("InsertService")
local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local Promise = require(Parent.Promise)

require(script.Parent.types)

local function createAssetSource(p1) -- line: 19
	-- upvalues: Promise (copy)
	return function(n1: number) -- line: 20
		-- upvalues: Promise (copy), p1 (copy)
		return Promise.new(function(resolve, reject) -- line: 21
			-- upvalues: p1 (copy), n1 (copy)
			task.spawn(function() -- line: 22
				-- upvalues: p1 (copy), n1 (copy), reject (copy), resolve (copy)
				local ok, result = pcall(function() -- line: 23
					-- upvalues: p1 (copy), n1 (copy)
					return p1:LoadAsset(n1)
				end)

				if not ok or not result then
					return reject(`loadAsset failed for asset { n1 }: { tostring(result) }`)
				end

				local AvatarBackground = result:FindFirstChild("AvatarBackground")
				local v22 = AvatarBackground and AvatarBackground:FindFirstChild("ImageId")
				local v23 = AvatarBackground and AvatarBackground:FindFirstChild("Color")

				if not AvatarBackground or not v22 or not v23 then
					result:Destroy()

					return reject(`asset { n1 } missing AvatarBackground/ImageId/Color`)
				end

				local Value = v22.Value
				local Value2 = v23.Value

				result:Destroy()

				return resolve({
					imageId = Value,
					backgroundColor = Value2
				})
			end)
		end)
	end
end

return {
	create = createAssetSource,
	default = function(n2: number) -- line: 20
		-- upvalues: Promise (copy), InsertService (copy)
		return Promise.new(function(resolve, reject) -- line: 21
			-- upvalues: InsertService (copy), n2 (copy)
			task.spawn(function() -- line: 22
				-- upvalues: InsertService (copy), n2 (copy), reject (copy), resolve (copy)
				local ok, result = pcall(function() -- line: 23
					-- upvalues: InsertService (copy), n2 (copy)
					return InsertService:LoadAsset(n2)
				end)

				if not ok or not result then
					return reject(`loadAsset failed for asset { n2 }: { tostring(result) }`)
				end

				local AvatarBackground = result:FindFirstChild("AvatarBackground")
				local v15 = AvatarBackground and AvatarBackground:FindFirstChild("ImageId")
				local v16 = AvatarBackground and AvatarBackground:FindFirstChild("Color")

				if not AvatarBackground or not v15 or not v16 then
					result:Destroy()

					return reject(`asset { n2 } missing AvatarBackground/ImageId/Color`)
				end

				local Value = v15.Value
				local Value3 = v16.Value

				result:Destroy()

				return resolve({
					imageId = Value,
					backgroundColor = Value3
				})
			end)
		end)
	end
}
