export const setGeoid = (geoid) => {
    return {
        type: 'SET_GEOID',
        payload: {
            geoid
        }
    }
}

export const storeData = (data, name) => {
    return {
        type: 'SET_STORED_DATA',
        payload: {
            data,
            name
        }   
    }
}

export const currentData = (data) => {
    return {
        type: 'SET_CURRENT_DATA',
        payload: {
            data
        }
    }
}