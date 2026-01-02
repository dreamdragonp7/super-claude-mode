// Hygen prompt for generating schema for existing API endpoint
module.exports = {
  prompt: ({ inquirer }) => {
    const questions = [
      {
        type: 'input',
        name: 'router_path',
        message: 'Path to the router (e.g., apps/api/routers/prediction.py):',
      },
    ]
    return inquirer.prompt(questions).then(answers => {
      const path = answers.router_path
      const parts = path.split('/')
      const filename = parts[parts.length - 1]
      const name = filename.replace(/\.py$/, '')
      // Convert snake_case to PascalCase for class names
      const className = name
        .split('_')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join('')

      return {
        name,
        className,
      }
    })
  },
}
