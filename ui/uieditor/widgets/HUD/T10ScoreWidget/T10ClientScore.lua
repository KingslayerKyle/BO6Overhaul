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

local PostLoadFunc = function ( self, controller, menu )
	self:linkToElementModel( self, "clientNum", true, function ( clientModel )
		local clientNum = Engine.GetModelValue( clientModel )

		if clientNum then
			if self.healthSubscription ~= nil then
				self:removeSubscription( self.healthSubscription )
			end

			self.healthSubscription = self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_health_" .. clientNum ), function ( model )
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

			self.armorTierSubscription = self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_armor_vest_tier_" .. clientNum ), function ( model )
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

			self.armorPlateSubscription = self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_armor_vest_plate_" .. clientNum ), function ( model )
				SetArmorPlateHealth( controller, self.Armor1, 1, clientNum )
				SetArmorPlateHealth( controller, self.Armor2, 2, clientNum )
				SetArmorPlateHealth( controller, self.Armor3, 3, clientNum )
			end )

			if self.armorHealthSubscription ~= nil then
				self:removeSubscription( self.armorHealthSubscription )
			end

			self.armorHealthSubscription = self:subscribeToModel( Engine.GetModel( Engine.GetModelForController( controller ), "t10_armor_vest_health_" .. clientNum ), function ( model )
				SetArmorPlateHealth( controller, self.Armor1, 1, clientNum )
				SetArmorPlateHealth( controller, self.Armor2, 2, clientNum )
				SetArmorPlateHealth( controller, self.Armor3, 3, clientNum )
			end )
		end
	end )
end

CoD.T10ClientScore = InheritFrom( LUI.UIElement )
CoD.T10ClientScore.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10ClientScore )
	self.id = "T10ClientScore"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.Circle = LUI.UIImage.new()
	self.Circle:setLeftRight( true, false, 53.5, 84 )
	self.Circle:setTopBottom( false, true, -132, -101.5 )
	self.Circle:setImage( RegisterImage( "hud_icon_minimap_player_squad_circle" ) )
	self.Circle:linkToElementModel( self, "clientNum", true, function ( model )
		local clientNum = Engine.GetModelValue( model )

		if clientNum then
			self.Circle:setRGB( ZombieClientScoreboardColor( clientNum ) )
		end
	end )
	self:addElement( self.Circle )

	self.CircleText = LUI.UIText.new()
	self.CircleText:setLeftRight( true, false, 53.5 - 100, 84 + 100 )
	self.CircleText:setTopBottom( false, true, -132, -101.5 )
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
	self.PortraitBG:setLeftRight( true, false, 27, 58 )
	self.PortraitBG:setTopBottom( false, true, -125, -91 )
	self.PortraitBG:setImage( RegisterImage( "ui_icon_portrait_background" ) )
	self.PortraitBG:setRGB( 1, 0, 0 )
	self:addElement( self.PortraitBG )

	self.Portrait = LUI.UIImage.new()
	self.Portrait:setLeftRight( true, false, 27, 58 )
	self.Portrait:setTopBottom( false, true, -125, -91 )
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
	self.PortraitOutline:setLeftRight( true, false, 27, 58 )
	self.PortraitOutline:setTopBottom( false, true, -125, -91 )
	self.PortraitOutline:setImage( RegisterImage( "ui_icon_portrait_outline" ) )
	self.PortraitOutline:setRGB( 0.70, 0.35, 0.35 )
	self:addElement( self.PortraitOutline )

	self.NameShadow = LUI.UIText.new()
	self.NameShadow:setLeftRight( true, true, -322, 0 )
	self.NameShadow:setTopBottom( false, true, -124 - 8, -109.5 + 8 )
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
	self.Name:setLeftRight( true, true, -322, 0 )
	self.Name:setTopBottom( false, true, -124 - 8, -109.5 + 8 )
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
	self.ScoreIcon:setLeftRight( true, false, 152, 168 )
	self.ScoreIcon:setTopBottom( false, true, -106, -90.5 )
	self.ScoreIcon:setImage( RegisterImage( "ui_icons_zombie_squad_info_essence" ) )
	self:addElement( self.ScoreIcon )

	self.ScoreShadow = LUI.UIText.new()
	self.ScoreShadow:setLeftRight( true, true, -203, 0 )
	self.ScoreShadow:setTopBottom( false, true, -112, -82.5 )
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
	self.Score:setLeftRight( true, true, -203, 0 )
	self.Score:setTopBottom( false, true, -112, -82.5 )
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

	self.HealthBG = LUI.UIImage.new()
	self.HealthBG:setLeftRight( true, false, 63.5, 148 )
	self.HealthBG:setTopBottom( false, true, -96.5, -93.5 )
	self.HealthBG:setImage( RegisterImage( "$white" ) )
	self.HealthBG:setRGB( 0, 0, 0 )
	self.HealthBG:setAlpha( 0.25 )
	self:addElement( self.HealthBG )
	
	self.HealthLoss = LUI.UIImage.new()
	self.HealthLoss:setLeftRight( true, false, 63.5, 148 )
	self.HealthLoss:setTopBottom( false, true, -96.5, -93.5 )
	self.HealthLoss:setImage( RegisterImage( "$white" ) )
	self.HealthLoss:setRGB( 0.74, 0.31, 0.16 )
	self.HealthLoss:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.HealthLoss:setShaderVector( 1, 0, 0, 0, 0 )
	self.HealthLoss:setShaderVector( 2, 1, 0, 0, 0 )
	self.HealthLoss:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.HealthLoss )

	self.Health = LUI.UIImage.new()
	self.Health:setLeftRight( true, false, 63.5, 148 )
	self.Health:setTopBottom( false, true, -96.5, -93.5 )
	self.Health:setImage( RegisterImage( "ximage_9d0232aa669af3a" ) )
	self.Health:setRGB( 1, 1, 1 )
	self.Health:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.Health:setShaderVector( 1, 0, 0, 0, 0 )
	self.Health:setShaderVector( 2, 1, 0, 0, 0 )
	self.Health:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.Health )

	self.Armor1 = LUI.UIImage.new()
	self.Armor1:setLeftRight( true, false, 63, 90.5 )
	self.Armor1:setTopBottom( false, true, -106.5, -96 )
	self.Armor1:setImage( RegisterImage( "blacktransparent" ) )
	self.Armor1:setRGB( 0, 0.47, 1 )
	self.Armor1:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.Armor1:setShaderVector( 0, 1, 0, 0, 0 )
	self.Armor1:setShaderVector( 1, 0, 0, 0, 0 )
	self.Armor1:setShaderVector( 2, 1, 0, 0, 0 )
	self.Armor1:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.Armor1 )

	self.Armor2 = LUI.UIImage.new()
	self.Armor2:setLeftRight( true, false, 63 + 28, 90.5 + 28 )
	self.Armor2:setTopBottom( false, true, -106.5, -96 )
	self.Armor2:setImage( RegisterImage( "blacktransparent" ) )
	self.Armor2:setRGB( 0, 0.47, 1 )
	self.Armor2:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.Armor2:setShaderVector( 0, 1, 0, 0, 0 )
	self.Armor2:setShaderVector( 1, 0, 0, 0, 0 )
	self.Armor2:setShaderVector( 2, 1, 0, 0, 0 )
	self.Armor2:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.Armor2 )

	self.Armor3 = LUI.UIImage.new()
	self.Armor3:setLeftRight( true, false, 63 + 28 + 28, 90.5 + 28 + 28 )
	self.Armor3:setTopBottom( false, true, -106.5, -96 )
	self.Armor3:setImage( RegisterImage( "blacktransparent" ) )
	self.Armor3:setRGB( 0, 0.47, 1 )
	self.Armor3:setMaterial( LUI.UIImage.GetCachedMaterial( "uie_wipe_normal" ) )
	self.Armor3:setShaderVector( 0, 1, 0, 0, 0 )
	self.Armor3:setShaderVector( 1, 0, 0, 0, 0 )
	self.Armor3:setShaderVector( 2, 1, 0, 0, 0 )
	self.Armor3:setShaderVector( 3, 0, 0, 0, 0 )
	self:addElement( self.Armor3 )

	self.Armor1Outline = LUI.UIImage.new()
	self.Armor1Outline:setLeftRight( true, false, 63, 90.5 )
	self.Armor1Outline:setTopBottom( false, true, -106.5, -96 )
	self.Armor1Outline:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.Armor1Outline )

	self.Armor2Outline = LUI.UIImage.new()
	self.Armor2Outline:setLeftRight( true, false, 63 + 28, 90.5 + 28 )
	self.Armor2Outline:setTopBottom( false, true, -106.5, -96 )
	self.Armor2Outline:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.Armor2Outline )

	self.Armor3Outline = LUI.UIImage.new()
	self.Armor3Outline:setLeftRight( true, false, 63 + 28 + 28, 90.5 + 28 + 28 )
	self.Armor3Outline:setTopBottom( false, true, -106.5, -96 )
	self.Armor3Outline:setImage( RegisterImage( "blacktransparent" ) )
	self:addElement( self.Armor3Outline )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 19 )

				self.Circle:completeAnimation()
				self.Circle:setAlpha( 0 )
				self.clipFinished( self.Circle, {} )

				self.CircleText:completeAnimation()
				self.CircleText:setAlpha( 0 )
				self.clipFinished( self.CircleText, {} )

				self.PortraitBG:completeAnimation()
				self.PortraitBG:setAlpha( 0 )
				self.clipFinished( self.PortraitBG, {} )

				self.Portrait:completeAnimation()
				self.Portrait:setAlpha( 0 )
				self.clipFinished( self.Portrait, {} )

				self.PortraitOutline:completeAnimation()
				self.PortraitOutline:setAlpha( 0 )
				self.clipFinished( self.PortraitOutline, {} )

				self.NameShadow:completeAnimation()
				self.NameShadow:setAlpha( 0 )
				self.clipFinished( self.NameShadow, {} )

				self.Name:completeAnimation()
				self.Name:setAlpha( 0 )
				self.clipFinished( self.Name, {} )

				self.ScoreIcon:completeAnimation()
				self.ScoreIcon:setAlpha( 0 )
				self.clipFinished( self.ScoreIcon, {} )

				self.ScoreShadow:completeAnimation()
				self.ScoreShadow:setAlpha( 0 )
				self.clipFinished( self.ScoreShadow, {} )

				self.Score:completeAnimation()
				self.Score:setAlpha( 0 )
				self.clipFinished( self.Score, {} )

				self.HealthBG:completeAnimation()
				self.HealthBG:setAlpha( 0 )
				self.clipFinished( self.HealthBG, {} )

				self.HealthLoss:completeAnimation()
				self.HealthLoss:setAlpha( 0 )
				self.clipFinished( self.HealthLoss, {} )

				self.Health:completeAnimation()
				self.Health:setAlpha( 0 )
				self.clipFinished( self.Health, {} )

				self.Armor1:completeAnimation()
				self.Armor1:setAlpha( 0 )
				self.clipFinished( self.Armor1, {} )

				self.Armor2:completeAnimation()
				self.Armor2:setAlpha( 0 )
				self.clipFinished( self.Armor2, {} )

				self.Armor3:completeAnimation()
				self.Armor3:setAlpha( 0 )
				self.clipFinished( self.Armor3, {} )

				self.Armor1Outline:completeAnimation()
				self.Armor1Outline:setAlpha( 0 )
				self.clipFinished( self.Armor1Outline, {} )

				self.Armor2Outline:completeAnimation()
				self.Armor2Outline:setAlpha( 0 )
				self.clipFinished( self.Armor2Outline, {} )

				self.Armor3Outline:completeAnimation()
				self.Armor3Outline:setAlpha( 0 )
				self.clipFinished( self.Armor3Outline, {} )
			end
		},
		Visible = {
			DefaultClip = function ()
				self:setupElementClipCounter( 19 )

				self.Circle:completeAnimation()
				self.Circle:setAlpha( 1 )
				self.clipFinished( self.Circle, {} )

				self.CircleText:completeAnimation()
				self.CircleText:setAlpha( 1 )
				self.clipFinished( self.CircleText, {} )

				self.PortraitBG:completeAnimation()
				self.PortraitBG:setAlpha( 1 )
				self.clipFinished( self.PortraitBG, {} )

				self.Portrait:completeAnimation()
				self.Portrait:setAlpha( 1 )
				self.clipFinished( self.Portrait, {} )

				self.PortraitOutline:completeAnimation()
				self.PortraitOutline:setAlpha( 1 )
				self.clipFinished( self.PortraitOutline, {} )

				self.NameShadow:completeAnimation()
				self.NameShadow:setAlpha( 1 )
				self.clipFinished( self.NameShadow, {} )

				self.Name:completeAnimation()
				self.Name:setAlpha( 1 )
				self.clipFinished( self.Name, {} )

				self.ScoreIcon:completeAnimation()
				self.ScoreIcon:setAlpha( 1 )
				self.clipFinished( self.ScoreIcon, {} )

				self.ScoreShadow:completeAnimation()
				self.ScoreShadow:setAlpha( 1 )
				self.clipFinished( self.ScoreShadow, {} )

				self.Score:completeAnimation()
				self.Score:setAlpha( 1 )
				self.clipFinished( self.Score, {} )

				self.HealthBG:completeAnimation()
				self.HealthBG:setAlpha( 0.25 )
				self.clipFinished( self.HealthBG, {} )

				self.HealthLoss:completeAnimation()
				self.HealthLoss:setAlpha( 1 )
				self.clipFinished( self.HealthLoss, {} )

				self.Health:completeAnimation()
				self.Health:setAlpha( 1 )
				self.clipFinished( self.Health, {} )

				self.Armor1:completeAnimation()
				self.Armor1:setAlpha( 1 )
				self.clipFinished( self.Armor1, {} )

				self.Armor2:completeAnimation()
				self.Armor2:setAlpha( 1 )
				self.clipFinished( self.Armor2, {} )

				self.Armor3:completeAnimation()
				self.Armor3:setAlpha( 1 )
				self.clipFinished( self.Armor3, {} )

				self.Armor1Outline:completeAnimation()
				self.Armor1Outline:setAlpha( 1 )
				self.clipFinished( self.Armor1Outline, {} )

				self.Armor2Outline:completeAnimation()
				self.Armor2Outline:setAlpha( 1 )
				self.clipFinished( self.Armor2Outline, {} )

				self.Armor3Outline:completeAnimation()
				self.Armor3Outline:setAlpha( 1 )
				self.clipFinished( self.Armor3Outline, {} )
			end
		}
	}

	self:mergeStateConditions( {
		{
			stateName = "Visible",
			condition = function ( menu, element, event )
				return not IsSelfModelValueEqualTo( element, controller, "playerScoreShown", 0 )
			end
		}
	} )
	self:linkToElementModel( self, "playerScoreShown", true, function ( model )
		menu:updateElementState( self, {
			name = "model_validation",
			menu = menu,
			modelValue = Engine.GetModelValue( model ),
			modelName = "playerScoreShown"
		} )
	end )

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
		element.HealthBG:close()
		element.HealthLoss:close()
		element.Health:close()
		element.Armor1:close()
		element.Armor2:close()
		element.Armor3:close()
		element.Armor1Outline:close()
		element.Armor2Outline:close()
		element.Armor3Outline:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
