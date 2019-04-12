import axios from 'axios';

export default class MemerAPI {
    static get BASE_URL() {
        return '';
    }

    static get AUTH_HEADER() {
        const token = document.cookie.replace(
          /(?:(?:^|.*;\s*)AuthorizationMemer\s*=\s*([^;]*).*$)|^.*$/,
          '$1'
        );
        return {
          headers: {
            Authorization: token
          }
        };
      }

    static Memes = class {

        static get MEMES_URL() {
            return `${MemerAPI.BASE_URL}/memes`;
        }

        static getUnseenMemes() {
            return axios.get(`${this.MEMES_URL}/unseen`, MemerAPI.AUTH_HEADER);
        }

        static addMeme(meme) {
            return axios.post(`${this.MEMES_URL}`, meme, MemerAPI.AUTH_HEADER);
        }

        static getMeme(id) {
            return axios.get(`${this.MEMES_URL}/${id}`);
        }

        static deleteMeme(id) {
            axios.delete(`${this.MEMES_URL}/${id}`);
        }

        static upvote(id) {
            return axios.post(`${this.MEMES_URL}/${id}/upvote`, MemerAPI.AUTH_HEADER);
        }

        static downvote(id) {
            return axios.post(`${this.MEMES_URL}/${id}/downvote`, MemerAPI.AUTH_HEADER);
        }

        static comment(comment, id) {
            
            const params = {
                contents: comment 
            }

            return axios.post(`${this.MEMES_URL}/${id}/comment`, params, MemerAPI.AUTH_HEADER);
        }

    }

    static User = class {

        static signup(name, email, password) {

            const params = {
                "name": name,
                "email": email,
                "password": password
            }

            return axios.post(`${MemerAPI.BASE_URL}/signup`, params);
        } 

        static login(email, password) {

            const params = {
                "email": email,
                "password": password
            }

            return axios.post(`${MemerAPI.BASE_URL}/login`, params);
        }

    }
}