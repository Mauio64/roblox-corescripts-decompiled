local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Foundation = require(Parent.Foundation)
local SharedFlags = require(Parent.SharedFlags)
local getIconRichText = Foundation.Utility.getIconRichText
local IconName = Foundation.Enums.IconName
local FFlagUpdateTranslateInReportRevamp = SharedFlags.FFlagUpdateTranslateInReportRevamp
local FFlagAbuseReportMenuV2 = SharedFlags.FFlagAbuseReportMenuV2

local function getWrappedText(p1, s1: string, color3: Color3) -- line: 66
	-- upvalues: FFlagAbuseReportMenuV2 (copy), getIconRichText (copy), IconName (copy)
	local v21 = "{" .. p1.type .. "Start}"
	local v22 = "{" .. p1.type .. "End}"

	if p1.type == "link" then
		if s1:find(v21) == nil or s1:find(v22) == nil then
			return s1, nil
		end

		return if not FFlagAbuseReportMenuV2 then s1:gsub(`{ v21 }(.-){ v22 }`, string.format("<font color=\"rgb(%d, %d, %d)\">%s</font>", math.floor(color3.R * 255), math.floor(color3.G * 255), math.floor(color3.B * 255), "%1")) else string.gsub(s1, `{ v21 }(.-){ v22 }`, "%1 " .. getIconRichText(IconName.ArrowUpRightFromSquare)), p1
	end

	if p1.type == "strong" then
		local v23 = string.gsub(s1, v21, "<b>")

		return string.gsub(v23, v22, "</b>"), nil
	end

	warn("Unknown wrapper type: " .. tostring(p1.type))

	return s1, nil
end

local u9 = nil

local function resolveParams(t1: {[any]: any}, t2: {[any]: any}?) -- line: 100
	-- upvalues: u9 (ref)
	if t2 == nil then
		return nil
	end

	local t3 = {}

	for k, v in pairs(t2) do
		if type(v) == "string" then
			t3[k] = v
		else
			t3[k] = u9(t1, v)
		end
	end

	return t3
end

function u9(t4: {[any]: any}, p2) -- line: 181
	-- upvalues: FFlagUpdateTranslateInReportRevamp (copy), resolveParams (copy)
	if p2 == nil then
		return ""
	end

	if type(p2) == "string" then
		return p2
	end

	local v42 = p2["$translate"]
	local params = p2.params
	local v44 = nil

	if FFlagUpdateTranslateInReportRevamp then
		v44 = resolveParams(t4, params)
	end

	local v45 = t4[v42] or v42

	if FFlagUpdateTranslateInReportRevamp and v44 ~= nil then
		v45 = v45:gsub("{(.-)}", v44)
	elseif params ~= nil then
		v45 = v45:gsub("{(.-)}", params)
	end

	return (v45:gsub("{%w+Start}(.-)({%w+End})", "%1"):gsub("{%w+Start}", ""):gsub("{%w+End}", ""))
end

return {
	mergeTranslationParams = function(p3, t5: {[any]: any}) -- line: 38
		if type(p3) == "string" then
			return p3
		end

		local t6 = {}

		if p3.params then
			for k, v in pairs(p3.params) do
				t6[k] = v
			end
		end

		for k, v in pairs(t5) do
			t6[k] = v
		end

		return {
			["$translate"] = p3["$translate"],
			params = t6,
			wrappers = p3.wrappers
		}
	end,
	translateIntoString = u9,
	translateIntoRichTextString = function(t7: {[any]: any}, p4, color3: Color3) -- line: 125
		-- upvalues: FFlagUpdateTranslateInReportRevamp (copy), resolveParams (copy), getWrappedText (copy)
		if p4 == nil then
			return "", nil
		end

		if type(p4) == "string" then
			return p4, nil
		end

		if type(p4) ~= "table" then
			return tostring(p4), nil
		end

		local v32 = p4["$translate"]

		if not v32 or type(v32) ~= "string" then
			return "", nil
		end

		local params = p4.params
		local v34 = nil

		if FFlagUpdateTranslateInReportRevamp then
			v34 = resolveParams(t7, params)
		end

		local v35 = t7[v32] or v32
		local v36 = nil

		if FFlagUpdateTranslateInReportRevamp and v34 ~= nil then
			v35 = v35:gsub("{(.-)}", v34)
		elseif params ~= nil then
			v35 = v35:gsub("{(.-)}", params)
		end

		if p4.wrappers then
			for _, v in pairs(p4.wrappers) do
				local v39

				v35, v39 = getWrappedText(v, v35, color3)

				if v39 ~= nil and v36 == nil then
					v36 = v39
				end
			end
		end

		return v35, v36
	end
}
