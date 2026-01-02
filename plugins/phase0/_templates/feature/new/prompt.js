module.exports = {
  prompt: ({ inquirer }) => {
    return inquirer.prompt([
      {
        type: 'input',
        name: 'name',
        message: 'Feature name (kebab-case):',
      },
      {
        type: 'input',
        name: 'description',
        message: 'Brief description:',
      },
      {
        type: 'list',
        name: 'type',
        message: 'Feature type:',
        choices: ['component', 'hook', 'full'],
      },
    ]);
  },
};
