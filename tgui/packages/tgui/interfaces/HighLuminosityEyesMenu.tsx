import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Button,
  ColorBox,
  Input,
  LabeledList,
  NumberInput,
  Section,
} from '../components';
import { Window } from '../layouts';

type EyeColorData = {
  mode: BooleanLike;
  hasOwner: BooleanLike;
  left: string;
  right: string;
};

type Data = {
  eyeColor: EyeColorData;
  lightColor: string;
  range: number;
};

enum ToUpdate {
  LightColor,
  LeftEye,
  RightEye,
}

const LightColorDisplay = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { lightColor } = data;
  return (
    <LabeledList.Item label="Color">
      <ColorBox color={lightColor} />{' '}
      <Button
        icon="palette"
        onClick={() => act('pick_color', { to_update: ToUpdate.LightColor })}
        tooltip="Brings up a color pick window to change the light color."
      />
      <Button
        icon="dice"
        onClick={() => act('random_color', { to_update: ToUpdate.LightColor })}
        tooltip="Randomizes the light color."
      />
      <Input
        value={lightColor}
        width={6}
        maxLength={7}
        onChange={(_, value) =>
          act('enter_color', {
            new_color: value,
            to_update: ToUpdate.LightColor,
          })
        }
      />
    </LabeledList.Item>
  );
};

const RangeDisplay = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { range } = data;
  return (
    <LabeledList.Item label="Range">
      <Button
        icon="minus-square-o"
        onClick={() => act('set_range', { new_range: range - 1 })}
        tooltip="Reduces the light range."
      />
      <Button
        icon="plus-square-o"
        onClick={() => act('set_range', { new_range: range + 1 })}
        tooltip="Increases the light range."
      />
      <NumberInput
        animated
        width="35px"
        step={1}
        stepPixelSize={5}
        value={range}
        minValue={0}
        maxValue={5}
        onDrag={(e, value) =>
          act('set_range', {
            new_range: value,
          })
        }
      />
    </LabeledList.Item>
  );
};

const EyeColorDisplay = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { eyeColor } = data;
  return (
    <>
      <LabeledList.Item label="Match Colors">
        <Button.Checkbox
          checked={eyeColor.mode}
          onClick={() => act('toggle_eye_color')}
          tooltip="Toggle the eye color mode."
        />
      </LabeledList.Item>
      {!eyeColor.mode && (
        <>
          <LabeledList.Item label="Left Eye">
            <ColorBox color={eyeColor.left} />{' '}
            <Button
              icon="palette"
              onClick={() => act('pick_color', { to_update: ToUpdate.LeftEye })}
              tooltip="Brings up a color pick window to change the light color."
            />
            <Button
              icon="dice"
              onClick={() =>
                act('random_color', { to_update: ToUpdate.LeftEye })
              }
              tooltip="Randomizes the light color."
            />
            <Input
              value={eyeColor.left}
              width={6}
              maxLength={7}
              onChange={(_, value) =>
                act('enter_color', {
                  new_color: value,
                  to_update: ToUpdate.LeftEye,
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="Right Eye">
            <ColorBox color={eyeColor.right} />{' '}
            <Button
              icon="palette"
              onClick={() =>
                act('pick_color', { to_update: ToUpdate.RightEye })
              }
              tooltip="Brings up a color pick window to change the light color."
            />
            <Button
              icon="dice"
              onClick={() =>
                act('random_color', { to_update: ToUpdate.RightEye })
              }
              tooltip="Randomizes the light color."
            />
            <Input
              value={eyeColor.right}
              width={6}
              maxLength={7}
              onChange={(_, value) =>
                act('enter_color', {
                  new_color: value,
                  to_update: ToUpdate.RightEye,
                })
              }
            />
          </LabeledList.Item>
        </>
      )}
    </>
  );
};

export const HighLuminosityEyesMenu = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { eyeColor } = data;
  return (
    <Window
      title="High Luminosity Eyes"
      width={eyeColor.hasOwner ? 262 : 225}
      height={eyeColor.hasOwner ? (eyeColor.mode ? 170 : 220) : 135}
    >
      <Window.Content>
        <Section fill title="Settings">
          <LabeledList>
            <LightColorDisplay />
            <RangeDisplay />
            {!!eyeColor.hasOwner && <EyeColorDisplay />}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
