function shallow_copy(t)
		local t2 = {}
		for k,v in pairs(t) do
				t2[k] = v
		end
		return t2
end

--the growth ray
minetest.register_craftitem("shrinkgrowrays:growth_ray", {
	description = "Growth Ray",
	inventory_image = "open_ai_growth_ray.png",
	
	on_use = function(itemstack, user, pointed_thing)
		local pos = user:getpos()
		pos.y = pos.y + 1.25
		local dir = user:get_look_dir()
		
		dir.x = dir.x * 15
		dir.y = dir.y * 15
		dir.z = dir.z * 15
		
		local object = minetest.add_entity(pos, "shrinkgrowrays:growth_ray_ray")
		
		object:setvelocity(dir)
	end,
})

--the growth ray orb
minetest.register_entity("shrinkgrowrays:growth_ray_ray", {
	visual = "sprite",
	physical = true,
	collide_with_objects = false,
	textures = {"open_ai_growth_ray_ray.png"},
	
	on_activate = function(self, staticdata, dtime_s)
		self.object:set_armor_groups({immortal = 1})
	end,
	
	on_step = function(self,dtime)
		local pos = self.object:getpos()
		local vel = self.object:getvelocity()
		
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 3)) do
			--only collide with other mobs and players
						
			--add exception if a nil entity exists around it
			if not object:is_player() and (object:get_luaentity() and object ~= self.object) then
				pos = object:getpos();
				orig_visual_sz = object:get_luaentity().visual_size;
				orig_colbox = object:get_luaentity().collisionbox;
				visual_sz = object:get_properties().visual_size;
				colbox = object:get_properties().collisionbox;
				if not orig_visual_sz then
					orig_visual_sz = shallow_copy(visual_sz)
					orig_colbox = shallow_copy(colbox)
					object:get_luaentity().visual_size = orig_visual_sz;
					object:get_luaentity().collisionbox = orig_colbox;
				end
				if visual_sz.x < orig_visual_sz.x * 4 and visual_sz.y < orig_visual_sz.y * 4 then
					visual_sz.x = visual_sz.x * 2
					visual_sz.y = visual_sz.y * 2
					pos.y = pos.y - colbox[2];
					if visual_sz.x == orig_visual_sz.x and visual_sz.y == orig_visual_sz.y then
						colbox = orig_colbox
					else
						for i = 1,table.getn(colbox) do
							colbox[i] = colbox[i] * 2
						end
					end
					object:setpos(pos);
					object:set_properties({ visual_size = visual_sz, collisionbox = colbox})
					self.object:remove()
				end
			end
		end
		
		if self.oldvel and ((self.oldvel.x ~= 0 and vel.x == 0) or (self.oldvel.y ~= 0 and vel.y == 0) or (self.oldvel.z ~= 0 and vel.z == 0)) then
			self.object:setvelocity({x=0,y=0,z=0})
			self.object:remove()
		end
		
		self.oldvel = vel
	end,
})



--the shrink ray
minetest.register_craftitem("shrinkgrowrays:shrink_ray", {
	description = "Shrink Ray",
	inventory_image = "open_ai_shrink_ray.png",
	
	on_use = function(itemstack, user, pointed_thing)
		local pos = user:getpos()
		pos.y = pos.y + 1.25
		local dir = user:get_look_dir()
		
		dir.x = dir.x * 15
		dir.y = dir.y * 15
		dir.z = dir.z * 15
		
		local object = minetest.add_entity(pos, "shrinkgrowrays:shrink_ray_ray")
		
		object:setvelocity(dir)
	end,
})

--the shrink ray orb
minetest.register_entity("shrinkgrowrays:shrink_ray_ray", {
	visual = "sprite",
	physical = true,
	collide_with_objects = false,
	textures = {"open_ai_shrink_ray_ray.png"},
	
	on_activate = function(self, staticdata, dtime_s)
		self.object:set_armor_groups({immortal = 1})
	end,
	
	on_step = function(self,dtime)
		local pos = self.object:getpos()
		local vel = self.object:getvelocity()
		
		for _,object in ipairs(minetest.env:get_objects_inside_radius(pos, 3)) do
			--only collide with other mobs and players
						
			--add exception if a nil entity exists around it
			if not object:is_player() and (object:get_luaentity() and object ~= self.object) then
				--pos = object:getpos();
				orig_visual_sz = object:get_luaentity().visual_size;
				orig_colbox = object:get_luaentity().collisionbox;
				visual_sz = object:get_properties().visual_size;
				colbox = object:get_properties().collisionbox;
				if not orig_visual_sz then
					orig_visual_sz = shallow_copy(visual_sz)
					orig_colbox = shallow_copy(colbox)
					object:get_luaentity().visual_size = orig_visual_sz;
					object:get_luaentity().collisionbox = orig_colbox;
				end
				if visual_sz.x > orig_visual_sz.x / 2 and visual_sz.y > orig_visual_sz.y / 2 then
					visual_sz.x = visual_sz.x / 2
					visual_sz.y = visual_sz.y / 2
					--pos.y = pos.y - colbox[2];
					if visual_sz.x == orig_visual_sz.x and visual_sz.y == orig_visual_sz.y then
						colbox = orig_colbox
					else
						for i = 1,table.getn(colbox) do
							colbox[i] = colbox[i] / 2
						end
					end
					--object:setpos(pos);
					object:set_properties({ visual_size = visual_sz, collisionbox = colbox})
					self.object:remove()
				end
			end
		end
		
		if self.oldvel and ((self.oldvel.x ~= 0 and vel.x == 0) or (self.oldvel.y ~= 0 and vel.y == 0) or (self.oldvel.z ~= 0 and vel.z == 0)) then
			self.object:setvelocity({x=0,y=0,z=0})
			self.object:remove()
		end
		
		self.oldvel = vel
	end,
})

if not minetest.registered_craftitems["mcl_core:iron_ingot"] then
	minetest.register_craft({
					output = "shrinkgrowrays:shrink_ray",
					recipe = {
									{"default:steel_ingot", "default:mese_crystal", "default:diamond"},
									{"default:steel_ingot", "",  ""}
					}
	})

	minetest.register_craft({
					output = "shrinkgrowrays:growth_ray",
					recipe = {
									{"default:steel_ingot", "default:diamond", "default:mese_crystal"},
									{"default:steel_ingot", "",  ""}
					}
	})
else
	minetest.register_craft({
					output = "shrinkgrowrays:shrink_ray",
					recipe = {
									{"mcl_core:iron_ingot", "mesecons:redstone", "mcl_core:diamond"},
									{"mcl_core:iron_ingot", "",  ""}
					}
	})

	minetest.register_craft({
					output = "shrinkgrowrays:growth_ray",
					recipe = {
									{"mcl_core:iron_ingot", "mcl_core:diamond", "mesecons:redstone"},
									{"mcl_core:iron_ingot", "",  ""}
					}
	})
end
