const fs = require('fs')
const parse = require('csv-parse')
const { toBuffer, keccak256 } = require('ethereumjs-util')
const _ = require('lodash')

const map = new Map()

fs.createReadStream('contracts-100000.csv').pipe(parse( { columns: true }))
  .on('data', (row) => {
    const code = toBuffer(row.code)
    if (code.length === 0) return
    const codeHash = keccak256(code)
    let val = map.get(codeHash.toString('hex'))
    if (val === undefined) {
      val = {
        code: code,
        addrs: new Set()
      }
    }
    val.addrs.add(row.address)
    map.set(codeHash.toString('hex'), val)
  })
  .on('end', () => {
    const res = []
    let totalAddrs = 0
    let totalCodeHashes = 0
    let distinctCodeSize = 0
    let totalCodeSize = 0
    for (let [h, v] of map) {
      res.push({ codeHash: h, accounts: v.addrs.size, codeLength: v.code.length, code: v.code.toString('hex') })
      totalCodeHashes++
      totalAddrs += v.addrs.size
      distinctCodeSize += v.code.length
      totalCodeSize += (v.addrs.size * v.code.length)
    }

    console.log(JSON.stringify(_.sortBy(res, ['accounts']), null, 2))
    console.log('codeHashes', totalCodeHashes, 'addrs', totalAddrs)
    console.log('distinctCodeSize', distinctCodeSize, 'totalCodeSize', totalCodeSize)
  })
