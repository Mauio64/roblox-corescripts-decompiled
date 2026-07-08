local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)
local t1 = {}
local t2 = {}

t2.__index = t2

function t2.new(t3: {[any]: any}?) -- line: 223
	-- upvalues: t2 (copy)
	return (setmetatable({
		capabilities = if t3 ~= nil and t3.capabilities ~= nil then t3.capabilities else nil,
		categories = if t3 ~= nil and t3.categories ~= nil then t3.categories else {},
		comment = if t3 ~= nil and t3.comment ~= nil then t3.comment else nil,
		metadata = if t3 ~= nil and t3.metadata ~= nil then t3.metadata else nil
	}, t2))
end
function t2.encode(p1) -- line: 234
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n1 = 0

	if p1.capabilities ~= nil then
		local v14 = p1.capabilities:encode()
		local v15, v16 = proto.writeTag(buf, n1, 1, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v15, v16, v14, buffer.len(v14))
	end

	if p1.categories ~= nil and #p1.categories > 0 then
		for _, v18 in p1.categories do
			local v19 = v18:encode()
			local v20, v21 = proto.writeTag(buf, n1, 2, proto.wireTypes.lengthDelimited)

			buf, n1 = proto.writeBuffer(v20, v21, v19, buffer.len(v19))
		end
	end

	if p1.comment ~= nil then
		local v22 = p1.comment:encode()
		local v23, v24 = proto.writeTag(buf, n1, 3, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v23, v24, v22, buffer.len(v22))
	end

	if p1.metadata ~= nil then
		local v25 = p1.metadata:encode()
		local v26, v27 = proto.writeTag(buf, n1, 4, proto.wireTypes.lengthDelimited)

		buf, n1 = proto.writeBuffer(v26, v27, v25, buffer.len(v25))
	end

	local buf2 = buffer.create(n1)

	buffer.copy(buf2, 0, buf, 0, n1)

	return buf2
end
function t2.decode(p2: buffer) -- line: 269
	-- upvalues: t2 (copy), proto (copy), t1 (copy)
	local v30 = t2.new()
	local n2 = 0

	while n2 < buffer.len(p2) do
		local v32, v33

		v32, v33, n2 = proto.readTag(p2, n2)

		if v33 == proto.wireTypes.varint then
			local v34

			v34, n2 = proto.readVarInt(p2, n2)
		elseif v33 == proto.wireTypes.lengthDelimited then
			if v32 == 1 then
				local v35

				v35, n2 = proto.readBuffer(p2, n2)
				v30.capabilities = t1.UniverseUserVoteFeedbackMetadataData_Capabilities.decode(v35)
			elseif v32 == 2 then
				local v36

				v36, n2 = proto.readBuffer(p2, n2)
				table.insert(v30.categories, t1.UniverseUserVoteFeedbackMetadataData_Category.decode(v36))
			elseif v32 == 3 then
				local v37

				v37, n2 = proto.readBuffer(p2, n2)
				v30.comment = t1.UniverseUserVoteFeedbackMetadataData_Comment.decode(v37)
			elseif v32 == 4 then
				local v38

				v38, n2 = proto.readBuffer(p2, n2)
				v30.metadata = t1.UniverseUserVoteFeedbackMetadataData_Metadata.decode(v38)
			else
				local v39, v40 = proto.readVarInt(p2, n2)

				n2 = v40 + v39
			end
		elseif v33 == proto.wireTypes.i32 then
			local v41

			v41, n2 = proto.readFixed32(p2, n2)
		elseif v33 == proto.wireTypes.i64 then
			local v42

			v42, n2 = proto.readFixed64(p2, n2)
		else
			error("Unsupported wire type: " .. v33)
		end
	end

	return v30
end
function t2.jsonEncode(p3) -- line: 327
	local t4 = {}

	if p3.capabilities ~= nil then
		t4.capabilities = p3.capabilities:jsonEncode()
	end

	if p3.categories ~= nil and #p3.categories > 0 then
		local t5 = {}

		for _, v47 in p3.categories do
			table.insert(t5, v47:jsonEncode())
		end

		t4.categories = t5
	end

	if p3.comment ~= nil then
		t4.comment = p3.comment:jsonEncode()
	end

	if p3.metadata ~= nil then
		t4.metadata = p3.metadata:jsonEncode()
	end

	return t4
end
function t2.jsonDecode(t6: {[any]: any}) -- line: 353
	-- upvalues: t2 (copy), t1 (copy)
	local v49 = t2.new()

	if t6.capabilities ~= nil then
		v49.capabilities = t1.UniverseUserVoteFeedbackMetadataData_Capabilities.jsonDecode(t6.capabilities)
	end

	if t6.categories ~= nil then
		local t7 = {}

		for _, v52 in t6.categories do
			table.insert(t7, t1.UniverseUserVoteFeedbackMetadataData_Category.jsonDecode(v52))
		end

		v49.categories = t7
	end

	if t6.comment ~= nil then
		v49.comment = t1.UniverseUserVoteFeedbackMetadataData_Comment.jsonDecode(t6.comment)
	end

	if t6.metadata ~= nil then
		v49.metadata = t1.UniverseUserVoteFeedbackMetadataData_Metadata.jsonDecode(t6.metadata)
	end

	return v49
end

t2.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteFeedbackMetadataData"
}
t1.UniverseUserVoteFeedbackMetadataData = t2
typeRegistry.default:register(t1.UniverseUserVoteFeedbackMetadataData)

local t8 = {}

t8.__index = t8

function t8.new(t9: {[any]: any}?) -- line: 398
	-- upvalues: t8 (copy)
	return (setmetatable({
		can_submit_review = t9 ~= nil and (t9.can_submit_review ~= nil and t9.can_submit_review),
		can_submit_comment = t9 ~= nil and (t9.can_submit_comment ~= nil and t9.can_submit_comment),
		can_submit_category_options = if t9 ~= nil and t9.can_submit_category_options ~= nil then t9.can_submit_category_options else nil
	}, t8))
end
function t8.encode(p4) -- line: 417
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n3 = 0

	if p4.can_submit_review then
		local v57, v58 = proto.writeTag(buf, n3, 1, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v57, v58, not p4.can_submit_review and 0 or 1)
	end

	if p4.can_submit_comment then
		local v59, v60 = proto.writeTag(buf, n3, 2, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v59, v60, not p4.can_submit_comment and 0 or 1)
	end

	if p4.can_submit_category_options ~= nil then
		local v61, v62 = proto.writeTag(buf, n3, 3, proto.wireTypes.varint)

		buf, n3 = proto.writeVarInt(v61, v62, not p4.can_submit_category_options and 0 or 1)
	end

	local buf3 = buffer.create(n3)

	buffer.copy(buf3, 0, buf, 0, n3)

	return buf3
end
function t8.decode(p5: buffer) -- line: 443
	-- upvalues: t8 (copy), proto (copy)
	local v65 = t8.new()
	local n4 = 0

	while n4 < buffer.len(p5) do
		local v67, v68

		v67, v68, n4 = proto.readTag(p5, n4)

		if v68 == proto.wireTypes.varint then
			if v67 == 1 then
				local v69

				v69, n4 = proto.readVarInt(p5, n4)
				v65.can_submit_review = v69 ~= 0
			elseif v67 == 2 then
				local v70

				v70, n4 = proto.readVarInt(p5, n4)
				v65.can_submit_comment = v70 ~= 0
			elseif v67 == 3 then
				local v71

				v71, n4 = proto.readVarInt(p5, n4)
				v65.can_submit_category_options = v71 ~= 0
			else
				local v72

				v72, n4 = proto.readVarInt(p5, n4)
			end
		elseif v68 == proto.wireTypes.lengthDelimited then
			local v73, v74 = proto.readVarInt(p5, n4)

			n4 = v74 + v73
		elseif v68 == proto.wireTypes.i32 then
			local v75

			v75, n4 = proto.readFixed32(p5, n4)
		elseif v68 == proto.wireTypes.i64 then
			local v76

			v76, n4 = proto.readFixed64(p5, n4)
		else
			error("Unsupported wire type: " .. v68)
		end
	end

	return v65
end
function t8.jsonEncode(p6) -- line: 498
	local t10 = {}

	if p6.can_submit_review then
		t10.canSubmitReview = p6.can_submit_review
	end

	if p6.can_submit_comment then
		t10.canSubmitComment = p6.can_submit_comment
	end

	if p6.can_submit_category_options ~= nil then
		t10.canSubmitCategoryOptions = p6.can_submit_category_options
	end

	return t10
end
function t8.jsonDecode(t11: {[any]: any}) -- line: 518
	-- upvalues: t8 (copy)
	local v80 = t8.new()

	if t11.can_submit_review ~= nil then
		v80.can_submit_review = t11.can_submit_review
	end

	if t11.canSubmitReview ~= nil then
		v80.can_submit_review = t11.canSubmitReview
	end

	if t11.can_submit_comment ~= nil then
		v80.can_submit_comment = t11.can_submit_comment
	end

	if t11.canSubmitComment ~= nil then
		v80.can_submit_comment = t11.canSubmitComment
	end

	if t11.can_submit_category_options ~= nil then
		v80.can_submit_category_options = t11.can_submit_category_options
	end

	if t11.canSubmitCategoryOptions ~= nil then
		v80.can_submit_category_options = t11.canSubmitCategoryOptions
	end

	return v80
end

t8.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Capabilities",
	fullName = "roblox.apppageplatform.shared.v1beta1.Capabilities"
}
t1.UniverseUserVoteFeedbackMetadataData_Capabilities = t8
typeRegistry.default:register(t1.UniverseUserVoteFeedbackMetadataData_Capabilities)

local t12 = {}

t12.__index = t12

function t12.new(t13: {[any]: any}?) -- line: 565
	-- upvalues: t12 (copy)
	return (setmetatable({
		type = if t13 ~= nil and t13.type ~= nil then t13.type else "",
		label = if t13 ~= nil and t13.label ~= nil then t13.label else "",
		allows_multiple_selections = t13 ~= nil and (t13.allows_multiple_selections ~= nil and t13.allows_multiple_selections),
		options = if t13 ~= nil and t13.options ~= nil then t13.options else {}
	}, t12))
end
function t12.encode(p7) -- line: 578
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n5 = 0

	if p7.type ~= nil and p7.type ~= "" then
		local v85, v86 = proto.writeTag(buf, n5, 1, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v85, v86, p7.type)
	end

	if p7.label ~= nil and p7.label ~= "" then
		local v87, v88 = proto.writeTag(buf, n5, 2, proto.wireTypes.lengthDelimited)

		buf, n5 = proto.writeString(v87, v88, p7.label)
	end

	if p7.allows_multiple_selections then
		local v89, v90 = proto.writeTag(buf, n5, 3, proto.wireTypes.varint)

		buf, n5 = proto.writeVarInt(v89, v90, not p7.allows_multiple_selections and 0 or 1)
	end

	if p7.options ~= nil and #p7.options > 0 then
		for _, v92 in p7.options do
			local v93 = v92:encode()
			local v94, v95 = proto.writeTag(buf, n5, 4, proto.wireTypes.lengthDelimited)

			buf, n5 = proto.writeBuffer(v94, v95, v93, buffer.len(v93))
		end
	end

	local buf4 = buffer.create(n5)

	buffer.copy(buf4, 0, buf, 0, n5)

	return buf4
end
function t12.decode(p8: buffer) -- line: 612
	-- upvalues: t12 (copy), proto (copy), t1 (copy)
	local v98 = t12.new()
	local n6 = 0

	while n6 < buffer.len(p8) do
		local v100, v101

		v100, v101, n6 = proto.readTag(p8, n6)

		if v101 == proto.wireTypes.varint then
			if v100 == 3 then
				local v102

				v102, n6 = proto.readVarInt(p8, n6)
				v98.allows_multiple_selections = v102 ~= 0
			else
				local v103

				v103, n6 = proto.readVarInt(p8, n6)
			end
		elseif v101 == proto.wireTypes.lengthDelimited then
			if v100 == 1 then
				local v104

				v104, n6 = proto.readBuffer(p8, n6)
				v98.type = buffer.tostring(v104)
			elseif v100 == 2 then
				local v105

				v105, n6 = proto.readBuffer(p8, n6)
				v98.label = buffer.tostring(v105)
			elseif v100 == 4 then
				local v106

				v106, n6 = proto.readBuffer(p8, n6)
				table.insert(v98.options, t1.UniverseUserVoteFeedbackMetadataData_Category_Option.decode(v106))
			else
				local v107, v108 = proto.readVarInt(p8, n6)

				n6 = v108 + v107
			end
		elseif v101 == proto.wireTypes.i32 then
			local v109

			v109, n6 = proto.readFixed32(p8, n6)
		elseif v101 == proto.wireTypes.i64 then
			local v110

			v110, n6 = proto.readFixed64(p8, n6)
		else
			error("Unsupported wire type: " .. v101)
		end
	end

	return v98
end
function t12.jsonEncode(p9) -- line: 675
	local t14 = {}

	if p9.type ~= nil and p9.type ~= "" then
		t14.type = p9.type
	end

	if p9.label ~= nil and p9.label ~= "" then
		t14.label = p9.label
	end

	if p9.allows_multiple_selections then
		t14.allowsMultipleSelections = p9.allows_multiple_selections
	end

	if p9.options ~= nil and #p9.options > 0 then
		local t15 = {}

		for _, v115 in p9.options do
			table.insert(t15, v115:jsonEncode())
		end

		t14.options = t15
	end

	return t14
end
function t12.jsonDecode(t16: {[any]: any}) -- line: 703
	-- upvalues: t12 (copy), t1 (copy)
	local v117 = t12.new()

	if t16.type ~= nil then
		v117.type = t16.type
	end

	if t16.label ~= nil then
		v117.label = t16.label
	end

	if t16.allows_multiple_selections ~= nil then
		v117.allows_multiple_selections = t16.allows_multiple_selections
	end

	if t16.allowsMultipleSelections ~= nil then
		v117.allows_multiple_selections = t16.allowsMultipleSelections
	end

	if t16.options ~= nil then
		local t17 = {}

		for _, v120 in t16.options do
			table.insert(t17, t1.UniverseUserVoteFeedbackMetadataData_Category_Option.jsonDecode(v120))
		end

		v117.options = t17
	end

	return v117
end

t12.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Category",
	fullName = "roblox.apppageplatform.shared.v1beta1.Category"
}
t1.UniverseUserVoteFeedbackMetadataData_Category = t12
typeRegistry.default:register(t1.UniverseUserVoteFeedbackMetadataData_Category)

local t18 = {}

t18.__index = t18

function t18.new(t19: {[any]: any}?) -- line: 751
	-- upvalues: t18 (copy)
	return (setmetatable({
		id = if t19 ~= nil and t19.id ~= nil then t19.id else "",
		label = if t19 ~= nil and t19.label ~= nil then t19.label else ""
	}, t18))
end
function t18.encode(p10) -- line: 763
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n7 = 0

	if p10.id ~= nil and p10.id ~= "" then
		local v125, v126 = proto.writeTag(buf, n7, 1, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v125, v126, p10.id)
	end

	if p10.label ~= nil and p10.label ~= "" then
		local v127, v128 = proto.writeTag(buf, n7, 2, proto.wireTypes.lengthDelimited)

		buf, n7 = proto.writeString(v127, v128, p10.label)
	end

	local buf5 = buffer.create(n7)

	buffer.copy(buf5, 0, buf, 0, n7)

	return buf5
end
function t18.decode(p11: buffer) -- line: 784
	-- upvalues: t18 (copy), proto (copy)
	local v131 = t18.new()
	local n8 = 0

	while n8 < buffer.len(p11) do
		local v133, v134

		v133, v134, n8 = proto.readTag(p11, n8)

		if v134 == proto.wireTypes.varint then
			local v135

			v135, n8 = proto.readVarInt(p11, n8)
		elseif v134 == proto.wireTypes.lengthDelimited then
			if v133 == 1 then
				local v136

				v136, n8 = proto.readBuffer(p11, n8)
				v131.id = buffer.tostring(v136)
			elseif v133 == 2 then
				local v137

				v137, n8 = proto.readBuffer(p11, n8)
				v131.label = buffer.tostring(v137)
			else
				local v138, v139 = proto.readVarInt(p11, n8)

				n8 = v139 + v138
			end
		elseif v134 == proto.wireTypes.i32 then
			local v140

			v140, n8 = proto.readFixed32(p11, n8)
		elseif v134 == proto.wireTypes.i64 then
			local v141

			v141, n8 = proto.readFixed64(p11, n8)
		else
			error("Unsupported wire type: " .. v134)
		end
	end

	return v131
end
function t18.jsonEncode(p12) -- line: 834
	local t20 = {}

	if p12.id ~= nil and p12.id ~= "" then
		t20.id = p12.id
	end

	if p12.label ~= nil and p12.label ~= "" then
		t20.label = p12.label
	end

	return t20
end
function t18.jsonDecode(t21: {[any]: any}) -- line: 850
	-- upvalues: t18 (copy)
	local v145 = t18.new()

	if t21.id ~= nil then
		v145.id = t21.id
	end

	if t21.label ~= nil then
		v145.label = t21.label
	end

	return v145
end

t18.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Category_Option",
	fullName = "roblox.apppageplatform.shared.v1beta1.Option"
}
t1.UniverseUserVoteFeedbackMetadataData_Category_Option = t18
typeRegistry.default:register(t1.UniverseUserVoteFeedbackMetadataData_Category_Option)

local t22 = {}

t22.__index = t22

function t22.new(t23: {[any]: any}?) -- line: 881
	-- upvalues: t22 (copy)
	return (setmetatable({
		label = if t23 ~= nil and t23.label ~= nil then t23.label else "",
		placeholder_text = if t23 ~= nil and t23.placeholder_text ~= nil then t23.placeholder_text else "",
		minimum_length = if t23 ~= nil and t23.minimum_length ~= nil then t23.minimum_length else 0,
		maximum_length = if t23 ~= nil and t23.maximum_length ~= nil then t23.maximum_length else 0
	}, t22))
end
function t22.encode(p13) -- line: 892
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n9 = 0

	if p13.label ~= nil and p13.label ~= "" then
		local v150, v151 = proto.writeTag(buf, n9, 1, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v150, v151, p13.label)
	end

	if p13.placeholder_text ~= nil and p13.placeholder_text ~= "" then
		local v152, v153 = proto.writeTag(buf, n9, 2, proto.wireTypes.lengthDelimited)

		buf, n9 = proto.writeString(v152, v153, p13.placeholder_text)
	end

	if p13.minimum_length ~= nil and p13.minimum_length ~= 0 then
		local v154, v155 = proto.writeTag(buf, n9, 3, proto.wireTypes.varint)

		buf, n9 = proto.writeVarInt(v154, v155, p13.minimum_length)
	end

	if p13.maximum_length ~= nil and p13.maximum_length ~= 0 then
		local v156, v157 = proto.writeTag(buf, n9, 4, proto.wireTypes.varint)

		buf, n9 = proto.writeVarInt(v156, v157, p13.maximum_length)
	end

	local buf6 = buffer.create(n9)

	buffer.copy(buf6, 0, buf, 0, n9)

	return buf6
end
function t22.decode(p14: buffer) -- line: 923
	-- upvalues: t22 (copy), proto (copy)
	local v160 = t22.new()
	local n10 = 0

	while n10 < buffer.len(p14) do
		local v162, v163

		v162, v163, n10 = proto.readTag(p14, n10)

		if v163 == proto.wireTypes.varint then
			if v162 == 3 then
				local v164

				v164, n10 = proto.readVarIntI32(p14, n10)
				v160.minimum_length = v164
			elseif v162 == 4 then
				local v165

				v165, n10 = proto.readVarIntI32(p14, n10)
				v160.maximum_length = v165
			else
				local v166

				v166, n10 = proto.readVarInt(p14, n10)
			end
		elseif v163 == proto.wireTypes.lengthDelimited then
			if v162 == 1 then
				local v167

				v167, n10 = proto.readBuffer(p14, n10)
				v160.label = buffer.tostring(v167)
			elseif v162 == 2 then
				local v168

				v168, n10 = proto.readBuffer(p14, n10)
				v160.placeholder_text = buffer.tostring(v168)
			else
				local v169, v170 = proto.readVarInt(p14, n10)

				n10 = v170 + v169
			end
		elseif v163 == proto.wireTypes.i32 then
			local v171

			v171, n10 = proto.readFixed32(p14, n10)
		elseif v163 == proto.wireTypes.i64 then
			local v172

			v172, n10 = proto.readFixed64(p14, n10)
		else
			error("Unsupported wire type: " .. v163)
		end
	end

	return v160
end
function t22.jsonEncode(p15) -- line: 983
	local t24 = {}

	if p15.label ~= nil and p15.label ~= "" then
		t24.label = p15.label
	end

	if p15.placeholder_text ~= nil and p15.placeholder_text ~= "" then
		t24.placeholderText = p15.placeholder_text
	end

	if p15.minimum_length ~= nil and p15.minimum_length ~= 0 then
		t24.minimumLength = p15.minimum_length
	end

	if p15.maximum_length ~= nil and p15.maximum_length ~= 0 then
		t24.maximumLength = p15.maximum_length
	end

	return t24
end
function t22.jsonDecode(t25: {[any]: any}) -- line: 1007
	-- upvalues: t22 (copy)
	local v176 = t22.new()

	if t25.label ~= nil then
		v176.label = t25.label
	end

	if t25.placeholder_text ~= nil then
		v176.placeholder_text = t25.placeholder_text
	end

	if t25.placeholderText ~= nil then
		v176.placeholder_text = t25.placeholderText
	end

	if t25.minimum_length ~= nil then
		v176.minimum_length = t25.minimum_length
	end

	if t25.minimumLength ~= nil then
		v176.minimum_length = t25.minimumLength
	end

	if t25.maximum_length ~= nil then
		v176.maximum_length = t25.maximum_length
	end

	if t25.maximumLength ~= nil then
		v176.maximum_length = t25.maximumLength
	end

	return v176
end

t22.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Comment",
	fullName = "roblox.apppageplatform.shared.v1beta1.Comment"
}
t1.UniverseUserVoteFeedbackMetadataData_Comment = t22
typeRegistry.default:register(t1.UniverseUserVoteFeedbackMetadataData_Comment)

local t26 = {}

t26.__index = t26

function t26.new(t27: {[any]: any}?) -- line: 1057
	-- upvalues: t26 (copy)
	return (setmetatable({
		disclaimer_label = if t27 ~= nil and t27.disclaimer_label ~= nil then t27.disclaimer_label else "",
		submit_button_label = if t27 ~= nil and t27.submit_button_label ~= nil then t27.submit_button_label else "",
		form_title_label = if t27 ~= nil and t27.form_title_label ~= nil then t27.form_title_label else ""
	}, t26))
end
function t26.encode(p16) -- line: 1069
	-- upvalues: proto (copy)
	local buf = buffer.create(0)
	local n11 = 0

	if p16.disclaimer_label ~= nil and p16.disclaimer_label ~= "" then
		local v181, v182 = proto.writeTag(buf, n11, 1, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v181, v182, p16.disclaimer_label)
	end

	if p16.submit_button_label ~= nil and p16.submit_button_label ~= "" then
		local v183, v184 = proto.writeTag(buf, n11, 2, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v183, v184, p16.submit_button_label)
	end

	if p16.form_title_label ~= nil and p16.form_title_label ~= "" then
		local v185, v186 = proto.writeTag(buf, n11, 3, proto.wireTypes.lengthDelimited)

		buf, n11 = proto.writeString(v185, v186, p16.form_title_label)
	end

	local buf7 = buffer.create(n11)

	buffer.copy(buf7, 0, buf, 0, n11)

	return buf7
end
function t26.decode(p17: buffer) -- line: 1095
	-- upvalues: t26 (copy), proto (copy)
	local v189 = t26.new()
	local n12 = 0

	while n12 < buffer.len(p17) do
		local v191, v192

		v191, v192, n12 = proto.readTag(p17, n12)

		if v192 == proto.wireTypes.varint then
			local v193

			v193, n12 = proto.readVarInt(p17, n12)
		elseif v192 == proto.wireTypes.lengthDelimited then
			if v191 == 1 then
				local v194

				v194, n12 = proto.readBuffer(p17, n12)
				v189.disclaimer_label = buffer.tostring(v194)
			elseif v191 == 2 then
				local v195

				v195, n12 = proto.readBuffer(p17, n12)
				v189.submit_button_label = buffer.tostring(v195)
			elseif v191 == 3 then
				local v196

				v196, n12 = proto.readBuffer(p17, n12)
				v189.form_title_label = buffer.tostring(v196)
			else
				local v197, v198 = proto.readVarInt(p17, n12)

				n12 = v198 + v197
			end
		elseif v192 == proto.wireTypes.i32 then
			local v199

			v199, n12 = proto.readFixed32(p17, n12)
		elseif v192 == proto.wireTypes.i64 then
			local v200

			v200, n12 = proto.readFixed64(p17, n12)
		else
			error("Unsupported wire type: " .. v192)
		end
	end

	return v189
end
function t26.jsonEncode(p18) -- line: 1150
	local t28 = {}

	if p18.disclaimer_label ~= nil and p18.disclaimer_label ~= "" then
		t28.disclaimerLabel = p18.disclaimer_label
	end

	if p18.submit_button_label ~= nil and p18.submit_button_label ~= "" then
		t28.submitButtonLabel = p18.submit_button_label
	end

	if p18.form_title_label ~= nil and p18.form_title_label ~= "" then
		t28.formTitleLabel = p18.form_title_label
	end

	return t28
end
function t26.jsonDecode(t29: {[any]: any}) -- line: 1170
	-- upvalues: t26 (copy)
	local v204 = t26.new()

	if t29.disclaimer_label ~= nil then
		v204.disclaimer_label = t29.disclaimer_label
	end

	if t29.disclaimerLabel ~= nil then
		v204.disclaimer_label = t29.disclaimerLabel
	end

	if t29.submit_button_label ~= nil then
		v204.submit_button_label = t29.submit_button_label
	end

	if t29.submitButtonLabel ~= nil then
		v204.submit_button_label = t29.submitButtonLabel
	end

	if t29.form_title_label ~= nil then
		v204.form_title_label = t29.form_title_label
	end

	if t29.formTitleLabel ~= nil then
		v204.form_title_label = t29.formTitleLabel
	end

	return v204
end

t26.descriptor = {
	name = "UniverseUserVoteFeedbackMetadataData_Metadata",
	fullName = "roblox.apppageplatform.shared.v1beta1.Metadata"
}
t1.UniverseUserVoteFeedbackMetadataData_Metadata = t26
typeRegistry.default:register(t1.UniverseUserVoteFeedbackMetadataData_Metadata)

return {
	UniverseUserVoteFeedbackMetadataData = t1.UniverseUserVoteFeedbackMetadataData,
	UniverseUserVoteFeedbackMetadataData_Capabilities = t1.UniverseUserVoteFeedbackMetadataData_Capabilities,
	UniverseUserVoteFeedbackMetadataData_Category = t1.UniverseUserVoteFeedbackMetadataData_Category,
	UniverseUserVoteFeedbackMetadataData_Category_Option = t1.UniverseUserVoteFeedbackMetadataData_Category_Option,
	UniverseUserVoteFeedbackMetadataData_Comment = t1.UniverseUserVoteFeedbackMetadataData_Comment,
	UniverseUserVoteFeedbackMetadataData_Metadata = t1.UniverseUserVoteFeedbackMetadataData_Metadata
}
