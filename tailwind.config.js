/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,ts}"],
  theme: {
    extend: {
      colors: {
        primary: "#20d3a4",
      },
      fontFamily: {
        Monsterrat: ["montserrat", "sans-serif"],
      },
    },
  },
  plugins: [],
};
