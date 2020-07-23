import express from 'express'
import axios from 'axios'
const router = express.Router()

const min = 1
const max = 808 // there are 807 pokemons

router.get('/', async (req, res) => {
  try {
    const randomNum =  Math.floor((Math.random() * (max - min) + min))
    const response = await axios.get(`https://pokeapi.co/api/v2/pokemon/${randomNum}`)

    const {id, height, name, weight, sprites: { front_default, back_default } } = response.data
    const pokemonResponse = {
      id,
      height,
      weight,
      name,
      front_default,
      back_default,
      img: `https://pokeres.bastionbot.org/images/pokemon/${randomNum}.png`
    }
    return res.status(200).send(pokemonResponse)
  }
  catch(e) {
    console.log(e)
    return res.status(e.response.status).send()
  }

})

export default router