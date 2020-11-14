import { INITIAL_STATE } from '../constants/defaults';

var reducer = (state = INITIAL_STATE, action) => {
    switch(action.type) {
        case 'SET_GEOID': 
            return {
                ...state,
                currentGeoid: action.payload.geoid
            };
        case 'SET_STORED_DATA':
            let obj = {
                ...state.storedData,
            }
            obj[action.payload.name] = action.payload.data
            return {
                ...state,
                storedData: obj
            };
        case 'SET_CURRENT_DATA':
            return {
                ...state,
                currentData: action.payload.data
            }
        default:
            return state;
    }
}

export default reducer;