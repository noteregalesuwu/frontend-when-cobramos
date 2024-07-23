import { Meme } from './memes.interface';

export interface MemeResponse {
  count: number;
  memes: Meme[];
}
