// Hygen prompt for generating index.ts for existing component
module.exports = {
  prompt: ({ inquirer }) => {
    const questions = [
      {
        type: 'input',
        name: 'component_path',
        message: 'Path to the component (e.g., src/components/Button/Button.tsx):',
      },
    ]
    return inquirer.prompt(questions).then(answers => {
      const path = answers.component_path
      const parts = path.split('/')
      const filename = parts[parts.length - 1]
      const name = filename.replace(/\.tsx?$/, '')
      const dir = parts.slice(0, -1).join('/')

      return {
        name,
        dir,
      }
    })
  },
}
