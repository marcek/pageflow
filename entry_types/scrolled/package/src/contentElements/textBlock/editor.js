import {editor, NoOptionsHintView} from 'pageflow-scrolled/editor';

editor.contentElementTypes.register('textBlock', {
  supportedPositions: ['inline'],

  configurationEditor() {
    this.tab('general', function() {
      this.view(NoOptionsHintView);
    });
  },

  split(configuration, insertIndex) {
    const value = getValue(configuration);

    return  [
      {
        ...configuration,
        value: value.slice(0, insertIndex),
      },
      {
        ...configuration,
        value: value.slice(insertIndex),
      }
    ];
  },

  merge(configurationA, configurationB) {
    const value = getValue(configurationA).concat(getValue(configurationB));

    return {
      ...configurationA,
      value,
    };
  },

  getLength(configuration) {
    return getValue(configuration).length;
  },

  handleDestroy(contentElement) {
    const transientState = contentElement.get('transientState') || {};

    if (!transientState.editableTextIsSingleBlock) {
      contentElement.postCommand({type: 'REMOVE'});
      return false;
    }
  }
});

function getValue(configuration) {
  // Value might still be empty if text block has not been edited
  return configuration.value || [{type: 'paragraph', children: [{text: ''}]}];
}
