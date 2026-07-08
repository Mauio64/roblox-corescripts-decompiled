local ParentParent = script.Parent.Parent
local getFFlagUGCValidationEnableFolderStructure = require(ParentParent.flags.getFFlagUGCValidationEnableFolderStructure)
local getFFlagUGCValidationCombineEntrypointResults = require(ParentParent.flags.getFFlagUGCValidationCombineEntrypointResults)
local getFFlagUGCValidationExtendSchemaToIgnoreDescendants = require(ParentParent.flags.getFFlagUGCValidationExtendSchemaToIgnoreDescendants)

local function checkName(p1, p2) -- line: 9
	if type(p1) == "table" then
		for _, v in pairs(p1) do
			if v == p2 then
				return true
			end
		end
	elseif type(p1) == "string" then
		return p1 == p2
	end

	return false
end
local function getReadableName(p3) -- line: 22
	if type(p3) == "table" then
		return table.concat(p3, " or ")
	end

	if type(p3) == "string" then
		return p3
	end

	return "*"
end
local function validateWithSchemaHelper(p4, p5, p6) -- line: 31
	-- upvalues: getFFlagUGCValidationExtendSchemaToIgnoreDescendants (copy), validateWithSchemaHelper (copy)
	if p5.ClassName ~= p4.ClassName then
		return {
			success = false
		}
	end

	local g17 = nil
	local g35 = nil
	local v34 = nil

	repeat
		if g17 or p4.Name == nil then
			g17 = false

			if getFFlagUGCValidationExtendSchemaToIgnoreDescendants() and p4._ignoreDescendants then
				assert(not p4._children, "if _ignoreDescendants is true, there should be no descendants in the schema as they would be ignored anyway")

				for _, descendant in p5:GetDescendants() do
					p6[descendant] = true
				end

				p6[p5] = true

				return {
					success = true
				}
			end

			if p4._children then
				for _, v in pairs(p4._children) do
					local v22 = false
					local v23 = nil

					for _, child in pairs(p5:GetChildren()) do
						if getFFlagUGCValidationExtendSchemaToIgnoreDescendants() and p6[child] then
							continue
						end

						local v26 = validateWithSchemaHelper(v, child, p6)

						if v26.success then
							v22 = true

							break
						end

						if v26.message then
							v23 = v26
						end
					end

					if not v22 and not v._optional then
						if v23 then
							return v23
						end

						local t1 = {
							success = false
						}
						local ClassName = v.ClassName
						local vName = v.Name

						t1.message = "Could not find a " .. ClassName .. " called " .. ((if type(vName) ~= "table" then type(vName) ~= "string" and "*" or vName else table.concat(vName, " or "))) .. " inside " .. p5.Name

						return t1
					end
				end
			end

			p6[p5] = true

			return {
				success = true
			}
		end

		local p4Name = p4.Name
		local p5Name = p5.Name

		if type(p4Name) == "table" then
			for _, v in pairs(p4Name) do
				if v == p5Name then
					v34 = true
					g35 = true
				end

				if g35 then
					break
				end
			end
		elseif type(p4Name) == "string" then
			v34 = p4Name == p5Name
			g35 = true
		end

		if not g35 then
			if not g35 then
				v34 = false
			end
		end

		g35 = false

		if not v34 then
			return {
				success = false
			}
		end

		g17 = true
	until not g17
end
local function validateWithSchema(p7, p8, _) -- line: 92
	-- upvalues: validateWithSchemaHelper (copy), getFFlagUGCValidationEnableFolderStructure (copy), getFFlagUGCValidationCombineEntrypointResults (copy)
	local g39 = nil
	local g43 = nil
	local g54 = nil
	local v53 = nil

	repeat
		if g39 or p8.ClassName ~= p7.ClassName then
			g39 = false

			local t2 = {
				success = false
			}
			local ClassName = p7.ClassName
			local p7Name = p7.Name

			t2.message = "Expected top-level instance to be a " .. ClassName .. " named " .. if type(p7Name) ~= "table" then type(p7Name) ~= "string" and "*" or p7Name else table.concat(p7Name, " or ")

			return t2
		end

		repeat
			if g43 or p7.Name == nil then
				g43 = false

				local t3 = {}
				local v45 = validateWithSchemaHelper(p7, p8, t3)

				if not v45.success then
					if getFFlagUGCValidationEnableFolderStructure() and getFFlagUGCValidationCombineEntrypointResults() then
						return {
							success = false,
							message = ""
						}
					end

					return v45
				end

				local t4 = {}

				for _, descendant in pairs(p8:GetDescendants()) do
					if t3[descendant] == nil then
						t4[#t4 + 1] = descendant:GetFullName()
					end
				end

				if #t4 > 0 then
					if getFFlagUGCValidationEnableFolderStructure() and getFFlagUGCValidationCombineEntrypointResults() then
						return {
							success = false,
							message = ""
						}
					end

					return {
						success = false,
						message = "Unexpected Descendants:\n" .. table.concat(t4, "\n")
					}
				end

				return {
					success = true
				}
			end

			local p7Name = p7.Name
			local p8Name = p8.Name

			if type(p7Name) == "table" then
				for _, v in pairs(p7Name) do
					if v == p8Name then
						v53 = true
						g54 = true
					end

					if g54 then
						break
					end
				end
			elseif type(p7Name) == "string" then
				v53 = p7Name == p8Name
				g54 = true
			end

			if not g54 then
				if not g54 then
					v53 = false
				end
			end

			g54 = false

			if not v53 then
				g39 = true
			end

			if g39 then
				break
			end

			g43 = true
		until not g43
	until not g39
end

return validateWithSchema
