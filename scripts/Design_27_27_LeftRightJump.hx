package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_27_27_LeftRightJump extends ActorScript
{
	public var _WalkLeft:String;
	public var _WalkRight:String;
	public var _IdleLeft:String;
	public var _IdleRight:String;
	public var _JumpLeft:String;
	public var _JumpRight:String;
	public var _TouchFloor:Bool;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("Walk Left", "_WalkLeft");
		nameMap.set("Walk Right", "_WalkRight");
		nameMap.set("Idle Left", "_IdleLeft");
		nameMap.set("Idle Right", "_IdleRight");
		nameMap.set("Jump Left", "_JumpLeft");
		nameMap.set("Jump Right", "_JumpRight");
		nameMap.set("TouchFloor", "_TouchFloor");
		_TouchFloor = false;
		
	}
	
	override public function init()
	{
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if(isKeyDown("left"))
				{
					actor.setAnimation("" + _WalkLeft);
					actor.setXVelocity(-20);
				}
				else if(isKeyDown("right"))
				{
					actor.setAnimation("" + _WalkRight);
					actor.setXVelocity(20);
				}
				else if(isKeyReleased("left"))
				{
					actor.setAnimation("" + _IdleLeft);
					actor.setXVelocity(0);
				}
				else if(isKeyReleased("right"))
				{
					actor.setAnimation("" + _IdleRight);
					actor.setXVelocity(0);
				}
			}
		});
		
		/* ======================= Member of Group ======================== */
		addCollisionListener(actor, function(event:Collision, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled && sameAsAny(getActorGroup(1),event.otherActor.getType(),event.otherActor.getGroup()))
			{
				_TouchFloor = true;
				propertyChanged("_TouchFloor", _TouchFloor);
			}
		});
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				if((isKeyDown("space") && (isKeyDown("left") && (_TouchFloor == true))))
				{
					actor.setYVelocity(-40);
					_TouchFloor = false;
					propertyChanged("_TouchFloor", _TouchFloor);
					actor.setAnimation("" + _JumpLeft);
				}
				else if((isKeyDown("space") && (isKeyDown("right") && (_TouchFloor == true))))
				{
					actor.setYVelocity(-40);
					_TouchFloor = false;
					propertyChanged("_TouchFloor", _TouchFloor);
					actor.setAnimation("" + _JumpRight);
				}
				else if((isKeyDown("space") && (_TouchFloor == true)))
				{
					actor.setYVelocity(-40);
					_TouchFloor = false;
					propertyChanged("_TouchFloor", _TouchFloor);
				}
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}