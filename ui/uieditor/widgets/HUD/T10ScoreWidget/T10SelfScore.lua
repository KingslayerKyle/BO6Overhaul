local SetArmorPlateHealth = function ( controller, element, plate, clientNum )
	local tier = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "t10_armor_vest_tier_" .. clientNum ) )
	local current_plate = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "t10_armor_vest_plate_" .. clientNum ) )
	local health = Engine.GetModelValue( Engine.GetModel( Engine.GetModelForController( controller ), "t10_armor_vest_health_" .. clientNum ) )

	if tier ~= nil and current_plate ~= nil and health ~= nil then
		if tier >= plate then
			element:setImage( RegisterImage( "ximage_453ae13ffe85797" ) )
		else
			element:setImage( RegisterImage( "blacktransparent" ) )
		end

		if current_plate > plate - 1 then
			element:setShaderVector( 0, 1, 0, 0, 0 )

		elseif current_plate < plate - 1 then
			element:setShaderVector( 0, 0, 0, 0, 0 )
			
		elseif current_plate == plate - 1 then
			element:setShaderVector( 0,
				CoD.GetVectorComponentFromString( health, 1 ),
				CoD.GetVectorComponentFromString( health, 2 ),
				CoD.GetVectorComponentFromString( health, 3 ),
				CoD.GetVectorComponentFromString( health, 4 ) )
		end
	end
end

local SetHealthText = function ( element, juggernautModel, healthModel )
	local juggernaut = Engine.GetModelValue( juggernautModel )
	local health = Engine.GetModelValue( healthModel )
	local maxHealth = 100

	if juggernaut > 0 then
		maxHealth = 200
	end

	element:setText( Engine.Localize( math.ceil( health * maxHealth ) ) )
end

local PostLoadFunc = function ( self, controller, menu )
	self:linkToElementModel( self, "clientNum", true, function ( clientModel )
		local clientNum = Engine.GetModelValue( clientModel )

		if clientNum then
			local controllerModel = Engine.GetModelForController( controller )
			local juggernautModel = Engine.GetModel( controllerModel, "hudItems.perks.juggernaut" )
			local healthModel = Engine.GetModel( controllerModel, "t10_health_" .. clientNum )
			local armorTierModel = Engine.GetModel( controllerModel, "t10_armor_vest_tier_" .. clientNum )
			local armorPlateModel = Engine.GetModel( controllerModel, "t10_armor_vest_plate_" .. clientNum )
			local armorHealthModel = Engine.GetModel( controllerModel, "t10_armor_vest_health_" .. clientNum )
			
			if self.juggernautSubscription ~= nil then
				self:removeSubscription( self.juggernautSubscription )
			end

			self.juggernautSubscription = self:subscribeToModel( juggernautModel, function ( model )
				SetHealthText( self.HealthText1, juggernautModel, healthModel )
			end )

			if self.healthSubscription ~= nil then
				self:removeSubscription( self.healthSubscription )
			end

			self.healthSubscription = self:subscribeToModel( healthModel, function ( model )
				SetHealthText( self.HealthText1, juggernautModel, healthModel )
				
				local health = Engine.GetModelValue( model )
				
				if health then
					self.Health:beginAnimation( "keyframe", 400, false, false, CoD.TweenType.Linear )

					self.Health:setShaderVector( 0,
						CoD.GetVectorComponentFromString( health, 1 ),
						CoD.GetVectorComponentFromString( health, 2 ),
						CoD.GetVectorComponentFromString( health, 3 ),
						CoD.GetVectorComponentFromString( health, 4 ) )

					self.HealthLoss:beginAnimation( "keyframe", 800, false, false, CoD.TweenType.Linear )

					self.HealthLoss:setShaderVector( 0,
						CoD.GetVectorComponentFromString( health, 1 ),
						CoD.GetVectorComponentFromString( health, 2 ),
						CoD.GetVectorComponentFromString( health, 3 ),
						CoD.GetVectorComponentFromString( health, 4 ) )
				end
			end )

			if self.armorTierSubscription ~= nil then
				self:removeSubscription( self.armorTierSubscription )
			end

			self.armorTierSubscription = self:subscribeToModel( armorTierModel, function ( model )
				SetArmorPlateHealth( controller, self.Armor1, 1, clientNum )
				SetArmorPlateHealth( controller, self.Armor2, 2, clientNum )
				SetArmorPlateHealth( controller, self.Armor3, 3, clientNum )

				local tier = Engine.GetModelValue( model )

				if tier ~= nil then
					local imageActive = RegisterImage( "ximage_5e497ce3e96701e" )
					local imageInactive = RegisterImage( "blacktransparent" )
				
					for i = 1, 3 do
						self["Armor" .. i .. "Outline"]:setImage( i <= tier and imageActive or imageInactive )
					end
				end
			end )

			if self.armorPlateSubscription ~= nil then
				self:removeSubscription( self.armorPlateSubscription )
			end

			self.armorPlateSubscription = self:subscribeToModel( armorPlateModel, function ( model )
				SetArmorPlateHealth( controller, self.Armor1, 1, clientNum )
				SetArmorPlateHealth( controller, self.Armor2, 2, clientNum )
				SetArmorPlateHealth( controller, self.Armor3, 3, clientNum )
			end )

			if self.armorHealthSubscription ~= nil then
				self:removeSubscription( self.armorHealthSubscription )
			end

			self.armorHealthSubscription = self:subscribeToModel( armorHealthModel, function ( model )
				SetArmorPlateHealth( controller, self.Armor1, 1, clientNum )
				SetArmorPlateHealth( controller, self.Armor2, 2, clientNum )
				SetArmorPlateHealth( controller, self.Armor3, 3, clientNum )
			end )
		end
	end )
end

CoD.T10SelfScore = InheritFrom( LUI.UIElement )
CoD.T10SelfScore.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10SelfScore )
	self.id = "T10SelfScore"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.Circle = LUI.UIImage.new()
	self.Circle:setLeftRight( true, false, 74, 111.5 )
	self.Circle:setTopBottom( false, true, -87.5, -50 )
	self.Circle:setImage( RegisterImage( "hud_icon_minimap_player_squad_circle" ) )
	self.Circle:linkToElementModel( self, "clientNum", true, function ( model )
		local clientNum = Engine.GetModelValue( model )

		if clientNum then
			self.Circle:setRGB( ZombieClientScoreboardColor( clientNum ) )
		end
	end )
	self:addElement( self.Circle )

	self.CircleText = LUI.UIText.new()
	self.CircleText:setLeftRight( true, false, 74 - 100, 111.5 + 100 )
	self.CircleText:setTopBottom( false, true, -87.5, -50 )
	self.CircleText:setText( Engine.Localize( "" ) )
	self.CircleText:setTTF( "fonts/kairos_sans_w1g_cn_bold.ttf" )
	self.CircleText:setRGB( 0, 0, 0 )
	self.CircleText:setScale( 0.5 )
	self.CircleText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.CircleText:linkToElementModel( self, "clientNum", true, function ( model )
		local clientNum = Engine.GetModelValue( model )

		if clientNum then
			self.CircleText:setText( Engine.Localize( clientNum + 1 ) )
		end
	end )
	self:addElement( self.CircleText )

	self.PortraitBG = LUI.UIImage.new()
	self.PortraitBG:setLeftRight( true, false, 27, 80 )
	self.PortraitBG:setTopBottom( false, true, -79, -19 )
	self.PortraitBG:setImage( RegisterImage( "ui_icon_portrait_background" ) )
	self.PortraitBG:setRGB( 1, 0, 0 )
	self:addElement( self.PortraitBG )

	self.Portrait = LUI.UIImage.new()
	self.Portrait:setLeftRight( true, false, 27, 80 )
	self.Portrait:setTopBottom( false, true, -79, -19 )
	self.Portrait:setImage( RegisterImage( "blacktransparent" ) )
	self.Portrait:linkToElementModel( self, "zombiePlayerIcon", true, function ( model )
		local zombiePlayerIcon = Engine.GetModelValue( model )

		if zombiePlayerIcon then
			if zombiePlayerIcon == "uie_t7_zm_hud_score_char1" then
				zombiePlayerIcon = "ui_icon_operators_nikolai"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char1_old" then
				zombiePlayerIcon = "ui_icon_operators_nikolai_waw"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char2" then
				zombiePlayerIcon = "ui_icon_operators_takeo"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char2_old" then
				zombiePlayerIcon = "ui_icon_operators_takeo_waw"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char3" then
				zombiePlayerIcon = "ui_icon_operators_dempsey"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char3_old" then
				zombiePlayerIcon = "ui_icon_operators_dempsey_waw"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char4" then
				zombiePlayerIcon = "ui_icon_operators_richtofen"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char4_old" then
				zombiePlayerIcon = "ui_icon_operators_richtofen_waw"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char5" then
				zombiePlayerIcon = "ui_icon_operators_jessica"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char6" then
				zombiePlayerIcon = "ui_icon_operators_jack"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char7" then
				zombiePlayerIcon = "ui_icon_operators_nero"

			elseif zombiePlayerIcon == "uie_t7_zm_hud_score_char8" then
				zombiePlayerIcon = "ui_icon_operators_floyd"
			end

			self.Portrait:setImage( RegisterImage( zombiePlayerIcon ) )
		end
	end )
	self:addElement( self.Portrait )

	self.PortraitOutline = LUI.UIImage.new()
	self.PortraitOutline:setLeftRight( true, false, 27, 80 )
	self.PortraitOutline:setTopBottom( false, true, -79, -19 )
	self.PortraitOutline:setImage( RegisterImage( "ui_icon_portrait_outline" ) )
	self.PortraitOutline:setRGB( 0.70, 0.35, 0.35 )
	self:addElement( self.PortraitOutline )

	self.NameShadow = LUI.UIText.new()
	self.NameShadow:setLeftRight( true, true, -290, 0 )
	self.NameShadow:setTopBottom( false, true, -88, -51 )
	self.NameShadow:setTTF( "fonts/noto_sans_cond_med.ttf" )
	self.NameShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.NameShadow:setShaderVector( 0, 0.1, 0, 0, 0 )
	self.NameShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.NameShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.NameShadow:setScale( 0.5 )
	self.NameShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.NameShadow:setRGB( 0.3, 0.3, 0.3 )
	self.NameShadow:linkToElementModel( self, "playerName", true, function ( model )
		local name = Engine.GetModelValue( model )

		if name then
			self.NameShadow:setText( Engine.Localize( name ) )
		end
	end )
	self:addElement( self.NameShadow )

	self.Name = LUI.UIText.new()
	self.Name:setLeftRight( true, true, -290, 0 )
	self.Name:setTopBottom( false, true, -88, -51 )
	self.Name:setTTF( "fonts/noto_sans_cond_med.ttf" )
	self.Name:setScale( 0.5 )
	self.Name:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.Name:linkToElementModel( self, "playerName", true, function ( model )
		local name = Engine.GetModelValue( model )

		if name then
			self.Name:setText( Engine.Localize( name ) )
		end
	end )
	self:addElement( self.Name )

	self.ScoreIcon = LUI.UIImage.new()
	self.ScoreIcon:setLeftRight( true, false, 151, 172 )
	self.ScoreIcon:setTopBottom( false, true, -39, -18.5 )
	self.ScoreIcon:setImage( RegisterImage( "ui_icons_zombie_squad_info_essence" ) )
	self:addElement( self.ScoreIcon )

	self.ScoreShadow = LUI.UIText.new()
	self.ScoreShadow:setLeftRight( true, true, -199, 0 )
	self.ScoreShadow:setTopBottom( false, true, -46, -9 )
	self.ScoreShadow:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.ScoreShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.ScoreShadow:setShaderVector( 0, 0.2, 0, 0, 0 )
	self.ScoreShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.ScoreShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.ScoreShadow:setRGB( 0.1, 0.1, 0.1 )
	self.ScoreShadow:setScale( 0.5 )
	self.ScoreShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.ScoreShadow:linkToElementModel( self, "playerScore", true, function ( model )
		local score = Engine.GetModelValue( model )

		if score then
			self.ScoreShadow:setText( Engine.Localize( score ) )
		end
	end )
	self:addElement( self.ScoreShadow )

	self.Score = LUI.UIText.new()
	self.Score:setLeftRight( true, true, -199, 0 )
	self.Score:setTopBottom( false, true, -46, -9 )
	self.Score:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.Score:setRGB( 0.9, 0.80, 0.2 )
	self.Score:setScale( 0.5 )
	self.Score:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.Score:linkToElementModel( self, "playerScore", true, function ( model )
		local score = Engine.GetModelValue( model )

		if score then
			self.Score:setText( Engine.Localize( score ) )
		end
	end )
	self:addElement( self.Score )

	self.JunkIcon = LUI.UIImage.new()
	self.JunkIcon:setLeftRight( true, false, 151 - 68, 172 - 68 )
	self.JunkIcon:setTopBottom( false, true, -39, -18.5 )
	self.JunkIcon:setImage( RegisterImage( "ui_icons_zombie_squad_info_salvage" ) )
	self:addElement( self.JunkIcon )

	self.JunkShadow = LUI.UIText.new()
	self.JunkShadow:setLeftRight( true, true, -199 - 65, 0 - 65 )
	self.JunkShadow:setTopBottom( false, true, -46, -9 )
	self.JunkShadow:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.JunkShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.JunkShadow:setShaderVector( 0, 0.2, 0, 0, 0 )
	self.JunkShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.JunkShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.JunkShadow:setRGB( 0.1, 0.1, 0.1 )
	self.JunkShadow:setScale( 0.5 )
	self.JunkShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.JunkShadow:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_junk" ), function ( model )
		local junk = Engine.GetModelValue( model )

		if junk then
			self.JunkShadow:setText( Engine.Localize( junk ) )
		end
	end )
	self:addElement( self.JunkShadow )

	self.Junk = LUI.UIText.new()
	self.Junk:setLeftRight( true, true, -199 - 65, 0 - 65 )
	self.Junk:setTopBottom( false, true, -46, -9 )
	self.Junk:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.Junk:setRGB( 1, 1, 1 )
	self.Junk:setScale( 0.5 )
	self.Junk:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.Junk:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_junk" ), function ( model )
		local junk = Engine.GetModelValue( model )

		if junk then
			self.Junk:setText( Engine.Localize( junk ) )
		end
	end )
	self:addElement( self.Junk )

	self.HealthBG = LUI.UIImage.new()
	self.HealthBG:setLeftRight( true, false, 85.5, 218 )
	self.HealthBG:setTopBottom( false, true, -45, -41 )
	self.HealthBG:setImage( RegisterImage( "$white" ) )
	self.HealthBG:setRGB( 0, 0, 0 )
	self.HealthBG:setAlpha( 0.25 )
	self:addElement( self.HealthBG )
	
	self.HealthLoss = LUI.UIImage.new()
	self.HealthLoss:setLeftRight( true, false, 85.5, 218 )
	self.HealthLoss:setTopBottom( false, true, -45, -41 )
	self.HealthLoss:setImage( RegisterImage( "$white" ) )
	self.HealthLoss:setRGB( 0.74, 0.31, 0.16 )
	self.HealthLoss:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.HealthLoss:setShaderVector( 0, 1, 0, 0, 0 )
	self.HealthLoss:setShaderVector( 1, 0, 0, 0, 0 )
	self.HealthLoss:setShaderVector( 2, 1, 0, 0, 0 )
	self.HealthLoss:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.HealthLoss )

	self.Health = LUI.UIImage.new()
	self.Health:setLeftRight( true, false, 85.5, 218 )
	self.Health:setTopBottom( false, true, -45, -41 )
	self.Health:setImage( RegisterImage( "ximage_9d0232aa669af3a" ) )
	self.Health:setRGB( 1, 1, 1 )
	self.Health:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.Health:setShaderVector( 0, 1, 0, 0, 0 )
	self.Health:setShaderVector( 1, 0, 0, 0, 0 )
	self.Health:setShaderVector( 2, 1, 0, 0, 0 )
	self.Health:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.Health )

	self.HealthText1 = LUI.UIText.new()
	self.HealthText1:setLeftRight( true, true, -180, 0 )
	self.HealthText1:setTopBottom( false, true, -72, -34 )
	self.HealthText1:setText( Engine.Localize( "" ) )
	self.HealthText1:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.HealthText1:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.HealthText1:setRGB( 1, 1, 1 )
	self.HealthText1:setScale( 0.5 )
	self:addElement( self.HealthText1 )

	self.HealthText2 = LUI.UIText.new()
	self.HealthText2:setLeftRight( true, true, -155, 0 )
	self.HealthText2:setTopBottom( false, true, -72 + 5, -44 + 5 )
	self.HealthText2:setText( Engine.Localize( "HP" ) )
	self.HealthText2:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.HealthText2:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_LEFT )
	self.HealthText2:setRGB( 1, 1, 1 )
	self.HealthText2:setScale( 0.5 )
	self:addElement( self.HealthText2 )

	self.Armor1 = LUI.UIImage.new()
	self.Armor1:setLeftRight( true, false, 85, 116.5 )
	self.Armor1:setTopBottom( false, true, -57, -44 )
	self.Armor1:setImage( RegisterImage( "blacktransparent" ) )
	self.Armor1:setRGB( 0, 0.47, 1 )
	self.Armor1:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.Armor1:setShaderVector( 0, 1, 0, 0, 0 )
	self.Armor1:setShaderVector( 1, 0, 0, 0, 0 )
	self.Armor1:setShaderVector( 2, 1, 0, 0, 0 )
	self.Armor1:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.Armor1 )

	self.Armor2 = LUI.UIImage.new()
	self.Armor2:setLeftRight( true, false, 85 + 32.5, 116.5 + 32.5 )
	self.Armor2:setTopBottom( false, true, -57, -44 )
	self.Armor2:setImage( RegisterImage( "blacktransparent" ) )
	self.Armor2:setRGB( 0, 0.47, 1 )
	self.Armor2:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.Armor2:setShaderVector( 0, 1, 0, 0, 0 )
	self.Armor2:setShaderVector( 1, 0, 0, 0, 0 )
	self.Armor2:setShaderVector( 2, 1, 0, 0, 0 )
	self.Armor2:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.Armor2 )

	self.Armor3 = LUI.UIImage.new()
	self.Armor3:setLeftRight( true, false, 85 + 32.5 + 32.5, 116.5 + 32.5 + 32.5 )
	self.Armor3:setTopBottom( false, true, -57, -44 )
	self.Armor3:setImage( RegisterImage( "blacktransparent" ) )
	self.Armor3:setRGB( 0, 0.47, 1 )
	self.Armor3:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.Armor3:setShaderVector( 0, 1, 0, 0, 0 )
	self.Armor3:setShaderVector( 1, 0, 0, 0, 0 )
	self.Armor3:setShaderVector( 2, 1, 0, 0, 0 )
	self.Armor3:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.Armor3 )

	self.Armor1Outline = LUI.UIImage.new()
	self.Armor1Outline:setLeftRight( true, false, 85, 116.5 )
	self.Armor1Outline:setTopBottom( false, true, -57, -44 )
	self.Armor1Outline:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.Armor1Outline )

	self.Armor2Outline = LUI.UIImage.new()
	self.Armor2Outline:setLeftRight( true, false, 85 + 32.5, 116.5 + 32.5 )
	self.Armor2Outline:setTopBottom( false, true, -57, -44 )
	self.Armor2Outline:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.Armor2Outline )

	self.Armor3Outline = LUI.UIImage.new()
	self.Armor3Outline:setLeftRight( true, false, 85 + 32.5 + 32.5, 116.5 + 32.5 + 32.5 )
	self.Armor3Outline:setTopBottom( false, true, -57, -44 )
	self.Armor3Outline:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.Armor3Outline )

	self.ArmorIcon = LUI.UIImage.new()
	self.ArmorIcon:setLeftRight( true, false, 224.5, 248 )
	self.ArmorIcon:setTopBottom( false, true, -70.5, -46.5 )
	self.ArmorIcon:setImage( RegisterImage( "ximage_7286ae4d343e4dd" ) )
	self:addElement( self.ArmorIcon )

	self.ArmorCountShadow = LUI.UIText.new()
	self.ArmorCountShadow:setLeftRight( true, false, 224.5 + 14, 248 + 14 )
	self.ArmorCountShadow:setTopBottom( false, true, -70.5 - 18, -32 - 18 )
	self.ArmorCountShadow:setText( Engine.Localize( "0" ) )
	self.ArmorCountShadow:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.ArmorCountShadow:setMaterial( LUI.UIImage.GetCachedMaterial( "sw4_2d_uie_font_cached_glow" ) )
	self.ArmorCountShadow:setShaderVector( 0, 0.2, 0, 0, 0 )
	self.ArmorCountShadow:setShaderVector( 1, 0.1, 0, 0, 0 )
	self.ArmorCountShadow:setShaderVector( 2, 1, 0, 0, 0 )
	self.ArmorCountShadow:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.ArmorCountShadow:setRGB( 0, 0, 0 )
	self.ArmorCountShadow:setScale( 0.5 )
	self.ArmorCountShadow:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_armor_vest_ammo" ), function ( model )
		local ammo = Engine.GetModelValue( model )

		if ammo then
			self.ArmorCountShadow:setText( Engine.Localize( ammo ) )
		end
	end )
	self:addElement( self.ArmorCountShadow )

	self.ArmorCount = LUI.UIText.new()
	self.ArmorCount:setLeftRight( true, false, 224.5 + 14, 248 + 14 )
	self.ArmorCount:setTopBottom( false, true, -70.5 - 18, -32 - 18 )
	self.ArmorCount:setText( Engine.Localize( "0" ) )
	self.ArmorCount:setTTF( "fonts/kairos_sans_w1g_cn.ttf" )
	self.ArmorCount:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.ArmorCount:setRGB( 1, 0.70, 0.25 )
	self.ArmorCount:setScale( 0.5 )
	self.ArmorCount:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_armor_vest_ammo" ), function ( model )
		local ammo = Engine.GetModelValue( model )

		if ammo then
			if ammo == 3 then
				self.ArmorCount:setRGB( 1, 0.70, 0.25 )
			else
				self.ArmorCount:setRGB( 1, 1, 1 )
			end

			self.ArmorCount:setText( Engine.Localize( ammo ) )
		end
	end )
	self:addElement( self.ArmorCount )

	self.ArmorIconDivider = LUI.UIImage.new()
	self.ArmorIconDivider:setLeftRight( true, false, 221.5, 251 )
	self.ArmorIconDivider:setTopBottom( false, true, -44.5, -41.5 )
	self.ArmorIconDivider:setImage( RegisterImage( "ximage_b1d6fa5f10cb50e" ) )
	self:addElement( self.ArmorIconDivider )

	self.ArmorIconButtonPrompt = LUI.UIImage.new()
	self.ArmorIconButtonPrompt:setLeftRight( true, false, 227.5, 245 )
	self.ArmorIconButtonPrompt:setTopBottom( false, true, -37, -18 )
	self.ArmorIconButtonPrompt:setImage( RegisterImage( "uie_t7_menu_frontend_buttonpanelfull" ) )
	self:addElement( self.ArmorIconButtonPrompt )

	self.ArmorIconButtonPromptText = LUI.UIText.new()
	self.ArmorIconButtonPromptText:setLeftRight( true, false, 227.5, 245 )
	self.ArmorIconButtonPromptText:setTopBottom( false, true, -37, -15 )
	self.ArmorIconButtonPromptText:setText( Engine.Localize( "" ) )
	self.ArmorIconButtonPromptText:setTTF( "fonts/monospac821_bt_wgl4_1.ttf" )
	self.ArmorIconButtonPromptText:setAlignment( Enum.LUIAlignment.LUI_ALIGNMENT_CENTER )
	self.ArmorIconButtonPromptText:setRGB( 0, 0, 0 )
	self.ArmorIconButtonPromptText:setScale( 0.5 )
	self.ArmorIconButtonPromptText:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "LastInput" ), function ( model )
		local text = Engine.GetKeyBindingLocalizedString( controller, "+actionslot 2" )

		if #text > 1 and not Engine.LastInput_Gamepad() then
			self.ArmorIconButtonPromptText:setText( Engine.Localize( "" ) )
		else
			self.ArmorIconButtonPromptText:setText( Engine.Localize( "[{+actionslot 2}]" ) )
		end
	end )
	self:addElement( self.ArmorIconButtonPromptText )

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Circle:close()
		element.CircleText:close()
		element.PortraitBG:close()
		element.Portrait:close()
		element.PortraitOutline:close()
		element.NameShadow:close()
		element.Name:close()
		element.ScoreIcon:close()
		element.ScoreShadow:close()
		element.Score:close()
		element.JunkIcon:close()
		element.JunkShadow:close()
		element.Junk:close()
		element.HealthBG:close()
		element.HealthLoss:close()
		element.Health:close()
		element.HealthText1:close()
		element.HealthText2:close()
		element.Armor1:close()
		element.Armor2:close()
		element.Armor3:close()
		element.Armor1Outline:close()
		element.Armor2Outline:close()
		element.Armor3Outline:close()
		element.ArmorIcon:close()
		element.ArmorCountShadow:close()
		element.ArmorCount:close()
		element.ArmorIconDivider:close()
		element.ArmorIconButtonPrompt:close()
		element.ArmorIconButtonPromptText:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
